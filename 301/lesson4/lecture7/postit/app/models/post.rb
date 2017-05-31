class Post < ActiveRecord::Base
  #set creator virtual attributes from User class to Post model
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
  #one-side polymorphic
  has_many :votes, as: :voteable

  validates :title, :url, :description, presence: true

  after_validation :generate_slug

  def total_votes
    self.up_votes - self.down_votes
  end
  
  def up_votes
    self.votes.where(vote: true).size
  end
  
  def down_votes
    self.votes.where(vote: false).size
  end

  def generate_slug
    self.slug = self.title.gsub(/\W/, '-').downcase
  end

  def to_param
    self.slug
  end
end