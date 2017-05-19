class Post < ActiveRecord::Base
  #set user attributes to Post model
  belongs_to :user
  has_many :comments
end