class QueueItem < ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  #has_one :category, through: :video
  delegate :category, to: :video #sends calls to category method to associated video

  validates_presence_of :video, :user
  validates_numericality_of :order, only_integer: true

  def category_name
    video.category ? video.category.label : 'No category'
  end

  def rating
    review ? review.rating : 0
  end

  def rating=(new_rating)
    clean_rating = cleanse_rating(new_rating)
    if review
      #bypasses validation, works for virtual attributes too
      review.update_column(:rating, clean_rating) unless review.rating == clean_rating
    else
      review = Review.new(video: video, user: user, rating: clean_rating)
      review.skip_comment_validation = true
      review.save
    end
  end

  def delete!
    self.deleted = true
    save
  end

  private
  def review
    @review ||= Review.find_by(video: video, user: user)
  end

  def cleanse_rating(rating)
    rating = rating.to_i
    rating = nil if rating==0
    rating
  end
end
