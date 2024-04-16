class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user, optional: true

  validates :content, presence: true
  validates :anonymous, inclusion: { in: [true, false] }
end
