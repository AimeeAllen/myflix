class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews
  validates :title, :description, presence: true

  def self.search_by_title(search_term)
    return [] if search_term.empty?
    where("lower(title) LIKE ?", "%#{search_term.downcase}%").order("created_at DESC")
  end

  def average_rating
    reviews.average(:rating).to_f
  end

  def recent_reviews
    reviews.order("created_at DESC").limit(8)
  end
end