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
      helpers.generate_film_data_object('seed', @likes_input, @reviews_input),
      { title: 'Code, Inc.',
        genre: 'Drama',
        cast: ['John Smith', 'Nina Jones-Ackels'],
        year: '2025',
        length: '122',
        age: '18',
        director: 'Bob Kowalsky',
        likes: 1,
        tag: 'Top 100',
        description: 'Will machines take over the world? Find out!',
        reviews: [{ review: 'Bad', author: 'Unknown', company: 'N/A' },
                  { review: 'Terrible. Never go to watch this movie, yopu will not enjoy it', author: 'Mark Zuckerberg', company: 'Meta' },
                  { review: 'We need to regulate AI, before its too late.', author: 'Elon Musk', company: 'Twitter' }]
      }
    ]

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end