require 'rails_helper'

RSpec.describe Tag, type: :model do
  subject(:tag) { described_class.new(name: 'Technology') }

  describe 'associations' do
    it { should have_many(:post_tags) }
    it { should have_many(:posts).through(:post_tags) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'methods' do
    describe '#name' do
      it 'returns the correct name' do
        expect(tag.name).to eq('Technology')
      end
    end
  end
end
