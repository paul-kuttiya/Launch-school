class User < ActiveRecord::Base
  has_many :posts
  has_many :comments

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  #validate pass only when create new user
  validates :password, presence: true, on: :create, length: {minimum: 3}
end