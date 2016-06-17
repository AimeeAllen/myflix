class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_presence_of :rating, :user, :video
  validates_presence_of :comment, unless: :skip_comment_validation
  validates_uniqueness_of :user_id, scope: :video_id

  attr_accessor :skip_comment_validation
end
