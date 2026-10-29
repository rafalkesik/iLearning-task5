module ApplicationHelper

  ANIMATIONS = {
    "pulse" => 2.0,
    "grow"  => 1.0,
    "fade"  => 1.5
  }.freeze

  # animation_sequence(%w[pulse grow pulse]) creates:
  # animation: pulse 2s ease-in-out 0s forwards,
  #            grow  1s ease-in-out 2s forwards,
  #            pulse 2s ease-in-out 4s forwards;
  def animation_sequence(names)
    delay = 0.0
    names.filter_map do |name|
      duration = ANIMATIONS[name.to_s]
      css = "#{name} #{duration}s ease-in-out #{delay}s forwards"
      delay += duration
      css
    end.join(", ")
  end
  
  

end
