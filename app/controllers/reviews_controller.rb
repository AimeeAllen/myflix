class ReviewsController < ApplicationController
  def create
    @video = Video.find(params[:video_id])
    @review = Review.new(comment: params[:review][:comment], rating: params[:review][:rating], user: current_user, video: @video)
    if @review.save
      flash[:success] = "Thank you for writing a video review."
      redirect_to @video
    else
      if @review.errors.messages[:user_id]
        flash[:danger] = "You have already made a review for this video"
      else
        flash[:danger] = "Please correct your review and resubmit it"
      end
      render 'videos/show'
    end
  end
end
