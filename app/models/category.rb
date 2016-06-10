class Category < ActiveRecord::Base
  has_many :videos, -> {order("title")} # sets a default order
  validates_presence_of :label

  def recent_videos
    Video.where(category: self).order("created_at DESC").limit(6)
    # Note: order on relations will trump explicit order
    # i.e. below code will take ordering from the videos has_many relation, not from the explicit order call
    #videos.order("created_at DESC").limit(6)
  end
end
