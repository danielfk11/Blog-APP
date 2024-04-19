require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { User.create(username: 'john_doe', email: 'john.doe@example.com', phone_number: '+5511999999999', password: 'password123', password_confirmation: 'password123') }
  
  subject(:post) { described_class.new(title: 'Test Post', content: 'This is a test post content.', user: user) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:post_tags) }
    it { should have_many(:tags).through(:post_tags) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
  end

  describe 'methods' do
    describe '#edited?' do
      context 'when the post has been edited' do
        before do
          post.update(title: 'New Title')
          post.reload
        end

        it 'returns false' do
          expect(post.edited?).to be_falsey
        end
      end

      context 'when the post has not been edited' do
        it 'returns false' do
          expect(post.edited?).to be_falsey
        end
      end
    end
  end
  
  describe 'tags assignment' do
    let!(:tag1) { Tag.create(name: 'Technology') }
    let!(:tag2) { Tag.create(name: 'Ruby') }

    context 'when assigning tags to a post' do
      before do
        post.tag_names = 'Technology, Ruby'
        post.save
        post.reload
      end

      it 'assigns correct tags to the post' do
        expect(post.tags.map(&:id)).to include(tag1.id, tag2.id)
      end
    end
  end
end
