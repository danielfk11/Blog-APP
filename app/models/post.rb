class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  
  def edited?
    updated_at != created_at
  end
end
