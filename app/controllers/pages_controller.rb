class PagesController < ApplicationController
  def home
    @animations = %w[pulse grow pulse]
    # @animations = %w[slide-in drop-in grow] # slide-in może być z 4 stron przynajmniej
    # @animations = %w[shrink grow-and-shrink fade-in]

    @texts = [
      "This fall",
      "Brad Pitt",
      "INCEPTION"
    ]

  end
end