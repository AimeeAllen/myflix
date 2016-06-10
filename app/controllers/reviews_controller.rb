class ReviewsController < ApplicationController
  def create
    @video = Video.find(params[:video_id])
    @review = Review.new(comment: params[:review][:comment], rating: params[:review][:rating], user: current_user, video: @video)
    if @review.save
      flash[:success] = "Thank you for writing a video review."
      redirect_to @video
    else
      flash[:danger] = "Please correct your review and resubmit it"
      render 'videos/show'
    end
  end
end
