class TextClipsController < ApplicationController
  CLIPS_DIR = Rails.root.join("public/clips")
  MAX_CLIPS = 6
  ID_FORMAT = /\A[0-9a-f]{16}\z/

  def new
  end

  def create
    texts = Array(params[:texts]).map { |t| t.to_s.strip.first(120) }.reject(&:blank?).first(MAX_CLIPS)

    if texts.empty?
      flash.now[:alert] = "Enter at least one text"
      return render :new, status: :unprocessable_entity
    end

    cleanup_old_clips
    ids = render_clips(texts)

    redirect_to text_clips_path(ids: ids.join(","))
  rescue TextClipGenerator::Error => e
    flash.now[:alert] = e.message
    render :new, status: :unprocessable_entity
  end

  def index
    ids = params[:ids].to_s.split(",").first(MAX_CLIPS).grep(ID_FORMAT)
    @clips = ids.select { |id| File.exist?(CLIPS_DIR.join("#{id}.mp4")) }
                .map { |id| "/clips/#{id}.mp4" }
  end

  private

  # Renders all texts in parallel. Same text -> same file, so repeats are free.
  def render_clips(texts)
    generator = TextClipGenerator # resolve the constant before starting threads

    jobs = texts.map do |text|
      id = Digest::SHA256.hexdigest(text)[0, 16]
      path = CLIPS_DIR.join("#{id}.mp4")

      thread = Thread.new do
        Rails.application.executor.wrap do
          generator.call(text: text, output_path: path) unless File.exist?(path)
        end
      end
      [id, thread]
    end

    jobs.each { |_, thread| thread.value } # re-raises any error from a thread
    jobs.map(&:first)
  end

  # No database, so just delete clips older than a day.
  def cleanup_old_clips
    Dir[CLIPS_DIR.join("*.mp4")].each do |file|
      File.delete(file) if File.mtime(file) < 1.day.ago
    end
  end
end