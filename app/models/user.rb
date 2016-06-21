class User < ActiveRecord::Base
  validates_presence_of :fullname, :email, :password
  validates :email, uniqueness: true

  has_many :reviews
  has_many :queue_items, -> {where(deleted: false).order('"order"')}
  has_many :videos, through: :queue_items

  # uses bcrypt gem to handle encryption from :password to :password_digest
  has_secure_password validations: false

  def normalise_queue_item_orders
    queue_items.each_with_index do |queue_item, i|
      queue_item.update_attributes(order: i+1)
    end
  end

  def queued_video?(video)
    queue_items.map(&:video_id).include?(video.id)
  end
end
