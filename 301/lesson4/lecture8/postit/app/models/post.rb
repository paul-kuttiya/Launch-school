class Post < ActiveRecord::Base
  include Voteable

  #set creator virtual attributes from User class to Post model
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
  
  validates :title, :url, :description, presence: true

  after_validation :generate_slug

  def generate_slug
    self.slug = self.title.gsub(/\W/, '-').downcase
  end

  def to_param
    self.slug
  end
end