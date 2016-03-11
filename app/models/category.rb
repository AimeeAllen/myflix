class Category < ActiveRecord::Base
  has_many :videos, -> {order("title")} # sets a default order
end
