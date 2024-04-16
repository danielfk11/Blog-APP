class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user, optional: true

  validates :content, presence: true

  def username
    user&.username || 'Anônimo'
  end
end
