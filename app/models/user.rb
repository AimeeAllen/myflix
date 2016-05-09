class User < ActiveRecord::Base
  validates_presence_of :fullname, :email, :password
  validates :email, uniqueness: true

  # uses bcrypt gem to handle encryption from :password to :password_digest
  has_secure_password validations: false
end
