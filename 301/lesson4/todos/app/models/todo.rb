class Todo < ActiveRecord::Base
  belongs_to :user

  default_scope order('completed_at ASC')

  validates :title, presence: true, length: { minimum: 3, maximum: 20 }
  validates :description, presence: true, length: { minimum: 5, maximum: 100 }
  validates :completed_at, presence: true
end