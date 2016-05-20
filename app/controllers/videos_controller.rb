class VideosController < ApplicationController
  def index
    @categories = Category.all
    # @videos_per_category = {}
    # @categories.each do |category|
    #   @videos_per_category[category.label.to_sym] = category.videos
    # end
  end

  def show
    @video = Video.find(params[:id])
    @reviews = @video.reviews
  end

  def search
    @videos = Video.search_by_title(params[:search_term])
  end
end
