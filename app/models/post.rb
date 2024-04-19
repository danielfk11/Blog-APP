class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :post_tags
  has_many :tags, through: :post_tags

  validates :title, presence: true
  validates :content, presence: true

  def edited?
    updated_at != created_at
  end
  
  attr_accessor :tag_names

  after_save :assign_tags

  private

  def assign_tags
    return unless tag_names

    self.tags = tag_names.split(',').map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end
end
