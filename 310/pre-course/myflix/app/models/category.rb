class Category < ActiveRecord::Base
  has_many :videos

  def to_param
    self.name
  end
end