require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { User.create(username: 'john_doe', email: 'john.doe@example.com', phone_number: '+5511999999999', password: 'password123', password_confirmation: 'password123') }
  let(:post) { Post.create(title: 'Test Post', content: 'This is a test post content.', user: user) }

  subject(:comment) { described_class.new(content: 'This is a test comment.', post: post, user: user) }

  describe 'associations' do
    it { should belong_to(:post) }
    it { should belong_to(:user).optional(true) }
  end

  describe 'validations' do
    it { should validate_presence_of(:content) }
    it { should validate_inclusion_of(:anonymous).in_array([true, false]) }
  end

  describe 'attributes' do
    it 'has content attribute' do
      expect(comment.content).to eq('This is a test comment.')
    end

    it 'has anonymous attribute' do
      expect(comment.anonymous).to be_nil
    end
  end
end
