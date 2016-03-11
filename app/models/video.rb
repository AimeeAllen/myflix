class Video < ActiveRecord::Base
  belongs_to :category
  validates :title, :description, presence: true

  def self.search_by_title(search_term)
    return [] if search_term.empty?
    where("lower(title) LIKE ?", "%#{search_term.downcase}%").order("created_at DESC")
  end
end