class PagesController < ApplicationController
  def home
    @animations = %w[pulse grow pulse]
  end
end