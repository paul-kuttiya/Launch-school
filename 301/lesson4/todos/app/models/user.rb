class User < ActiveRecord::Base
  has_many :todos

  validates :username, presence: true, uniqueness: true, length: {minimum: 3, maximum: 20}
  validates :password, presence: true, length: {minimum: 3, maximum: 20}
  
  has_secure_password validations: false
end