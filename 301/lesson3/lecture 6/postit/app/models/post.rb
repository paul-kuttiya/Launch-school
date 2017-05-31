class Post < ActiveRecord::Base
  #set creator virtual attributes from User class to Post model
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
  #one-side polymorphic
  has_many :votes, as: :voteable

  validates :title, :url, :description, presence: true

  def total_votes
    self.up_votes - self.down_votes
  end
  
  def up_votes
    self.votes.where(vote: true).size
  end
  
  def down_votes
    self.votes.where(vote: false).size
  end
end