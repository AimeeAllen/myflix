class User < ActiveRecord::Base
  validates_presence_of :fullname, :email, :password
  validates :email, uniqueness: true

  has_many :reviews
  has_many :queue_items, -> {where deleted: false}
  has_many :videos, through: :queue_items

  # uses bcrypt gem to handle encryption from :password to :password_digest
  has_secure_password validations: false

end
