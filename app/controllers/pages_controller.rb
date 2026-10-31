class PagesController < ApplicationController
  def home
    @animations = %w[pulse grow pulse]
    # @animations = %w[slide-in drop-in grow] # slide-in może być z 4 stron przynajmniej
    # @animations = %w[shrink grow-and-shrink fade-in]
    
    @DEFAULT_LIKES = @DEFAULT_REVIEWS = 4.5.freeze()
    @likes_input   = params.fetch(:likes, @DEFAULT_LIKES).to_f
    @reviews_input = params.fetch(:reviews, @DEFAULT_REVIEWS).to_f

    @texts = [
      ["This fall", "Brad Pitt", "INCEPTION"],
      ["Best film ever", "Penelopa Cruz", "Code, Inc."]
    ]

    @copy = [
      helpers.generate_film_data_object('0', @likes_input, @reviews_input),
      helpers.generate_film_data_object('1', @likes_input, @reviews_input),
    ]

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end