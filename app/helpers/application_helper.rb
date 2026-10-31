module ApplicationHelper

  ANIMATIONS = {
    "pulse"    => 2.0,
    "grow"     => 1.0,
    "fade"     => 2.0,
    "slide-in" => 1.0,
    "drop-in"  => 2.0,
    "shrink"   => 2.0,
    "grow-and-shrink" => 2.0,
    "fade-in"  => 2.0,
    # "fade-out" => 2.0,
  }.freeze

  FADE_OUT_DURATION = 0.5
  HOLD_DURATION     = 1.0

  # animation_sequence(%w[pulse grow pulse]) creates:
  # animation: pulse 2s ease-in-out 0s forwards,
  #            grow  1s ease-in-out 2s forwards,
  #            pulse 2s ease-in-out 4s forwards;
  def animation_sequence(animations)
    delay = 0.0
    animations.map do |animation|
      duration = ANIMATIONS[animation.to_s]
      main_css     = "#{animation} #{duration}s ease-in-out #{delay}s both"
      fade_out_css = "fade-out #{FADE_OUT_DURATION}s ease-in-out #{delay + duration + HOLD_DURATION}s forwards"
      delay += duration + HOLD_DURATION + FADE_OUT_DURATION
      
      "#{main_css}, #{fade_out_css}"
    end
  end
end
