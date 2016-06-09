class QueueItem < ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  #has_one :category, through: :video
  delegate :category, to: :video #sends calls to category method to associated video

  validates_presence_of :video, :user

  def category_name
    video.category ? video.category.label : 'No category'
  end

  def rating
    review = Review.find_by(video: video, user: user)
    review ? review.rating : 0
  end
end
