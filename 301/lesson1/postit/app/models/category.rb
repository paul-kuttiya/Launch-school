class Category < ActiveRecord::Base
  has_many :categories
  has_many :posts, through: :post_categories
end