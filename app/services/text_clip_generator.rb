# Renders a 5-second text animation (slide up + fade in, hold, fade out) to MP4
# using FFmpeg. Free, no external API.
#
#   TextClipGenerator.call(text: "Hello", output_path: Rails.root.join("public/clips/hello.mp4"))
class TextClipGenerator
  class Error < StandardError; end

  DURATION   = 5
  WIDTH      = 400
  HEIGHT     = 226
  BACKGROUND = "0x111827"
  FONT_SIZE  = 30
  MAX_LINE_CHARS = 24
  FFMPEG = ENV.fetch("FFMPEG_PATH", "ffmpeg")

  # Put a .ttf at app/assets/fonts/ if you want a custom font; otherwise we
  # fall back to common system fonts.
  FONT_CANDIDATES = [
    Rails.root.join("app/assets/fonts/Inter-Bold.ttf").to_s,
    "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",        # Linux
    "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf", # Linux
    "/System/Library/Fonts/Supplemental/Arial Bold.ttf",            # macOS
    "/Library/Fonts/Arial Bold.ttf"                                 # macOS
  ].freeze

  def self.call(**kwargs)
    new(**kwargs).call
  end

  def initialize(text:, output_path:)
    @text = text.to_s.strip
    @output_path = output_path.to_s
  end

  def call
    raise Error, "Text can't be blank" if @text.empty?
    raise Error, "ffmpeg is not installed (brew install ffmpeg / apt install ffmpeg)" unless ffmpeg?

    FileUtils.mkdir_p(File.dirname(@output_path))

    # Passing the text through a file means no escaping of quotes or colons,
    # and no shell-injection risk from user input.
    Tempfile.create(["clip_text", ".txt"]) do |file|
      file.write(wrapped_text)
      file.flush
      run_ffmpeg(file.path)
    end

    @output_path
  end

  private

  # Word-wrap long text so it fits the frame.
  def wrapped_text
    @wrapped_text ||= @text.gsub(/\s+/, " ").scan(/\S.{0,#{MAX_LINE_CHARS - 1}}(?=\s|\z)|\S+/).join("\n")
  end

  # Shrink the font for long lines so they never run off the screen.
  def font_size
    longest = wrapped_text.lines.map { |l| l.strip.length }.max.to_i
    [FONT_SIZE, (WIDTH * 0.86 / (longest * 0.62)).floor].min.clamp(12, FONT_SIZE)
  end

  def run_ffmpeg(text_file)
    cmd = [
      FFMPEG, "-y", "-loglevel", "error",
      "-f", "lavfi", "-i", "color=c=#{BACKGROUND}:s=#{WIDTH}x#{HEIGHT}:d=#{DURATION}:r=24",
      "-f", "lavfi", "-i", "anoisesrc=d=1:c=pink:a=0.5:r=44100",   # whoosh source
      "-f", "lavfi", "-i", "sine=f=880:d=0.6:r=44100",              # ping source
      "-filter_complex", filter_complex(text_file),
      "-map", "[v]", "-map", "[a]",
      "-c:v", "libx264", "-preset", "ultrafast", "-crf", "28", "-pix_fmt", "yuv420p",
      "-c:a", "aac", "-b:a", "96k", "-t", DURATION.to_s, "-movflags", "+faststart",
      @output_path
    ]

    output, status = Open3.capture2e(*cmd)
    raise Error, "FFmpeg failed: #{output}" unless status.success?
  end

  def filter_complex(text_file)
    [
      "[0:v]#{drawtext_filter(text_file)}[v]",
      # whoosh while the text slides in (first second)
      "[1:a]lowpass=f=1800,afade=t=in:d=0.5,afade=t=out:st=0.5:d=0.5[whoosh]",
      # soft ping as the text settles (~0.9s in)
      "[2:a]volume=0.35,afade=t=out:st=0.15:d=0.45,adelay=900|900[ping]",
      "[whoosh][ping]amix=inputs=2:duration=longest:normalize=0,apad=whole_dur=#{DURATION}[a]"
    ].join(";")
  end

  def drawtext_filter(text_file)
    [
      "drawtext=fontfile='#{ffmpeg_escape(font_path)}'",
      "textfile='#{ffmpeg_escape(text_file)}'",
      # expansion=none: otherwise a "%" in the text breaks rendering
      "expansion=none",
      "fontsize=#{font_size}",
      "fontcolor=white",
      "line_spacing=4",
      "x=(w-text_w)/2",
      # slides up 80px with ease-out during the first second
      "y=(h-text_h)/2+25*pow(1-min(t\\,1)\\,2)",
      # 1s fade in, hold, 1s fade out
      "alpha='if(lt(t,1),t,if(gt(t,#{DURATION - 1}),#{DURATION}-t,1))'"
    ].join(":")
  end

  def ffmpeg_escape(path)
    path.gsub("\\", "/").gsub(":", "\\:")
  end

  def font_path
    FONT_CANDIDATES.find { |f| File.exist?(f) } ||
      raise(Error, "No font found. Add a .ttf at app/assets/fonts/Inter-Bold.ttf")
  end

  def ffmpeg?
    system(FFMPEG, "-version", out: File::NULL, err: File::NULL)
  end
end
