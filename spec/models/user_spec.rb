require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { described_class.new(username: 'john_doe', email: 'danielfkiffer@outlook.com', phone_number: '+5511999999999', password: 'password123', password_confirmation: 'password123') }

  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('danielfkiffer@outlook.com').for(:email) }
    it { should_not allow_value('john.doe@example').for(:email) }
    
    it { should validate_presence_of(:phone_number) }
    it { should validate_uniqueness_of(:phone_number).case_insensitive }
    it { should allow_value('+5511999999999').for(:phone_number) }
    it { should_not allow_value('+550119999999').for(:phone_number) }
    
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(8) }
    it { should validate_confirmation_of(:password) }
    
    it 'has a valid factory' do
      expect(user).to be_valid
    end
  end

  describe 'associations' do
    it { should have_many(:posts).dependent(:destroy) }
  end

  describe '#authenticate' do
    context 'with a valid password' do
      it 'returns true' do
        expect(user.authenticate('password123')).to be_truthy
      end
    end

    context 'with an invalid password' do
      it 'returns false' do
        expect(user.authenticate('wrongpassword')).to be_falsey
      end
    end
  end

  describe '#password_required?' do
    context 'when creating a new record' do
      it 'returns true' do
        expect(user.send(:password_required?)).to be_truthy
      end
    end

    context 'when updating an existing record with password' do
      before { user.save! }
      
      it 'returns true' do
        user.password = 'newpassword123'
        user.updating_password = true
        expect(user.send(:password_required?)).to be_truthy
      end
    end

    context 'when updating an existing record without password' do
      before { user.save! }

      it 'returns false' do
        user.username = 'new_john_doe'
        user.updating_password = false
        expect(user.send(:password_required?)).to be_falsey
      end
    end
  end

  describe '#password_match' do
    context 'when password_confirmation matches password' do
      it 'does not add an error' do
        user.password_confirmation = 'password123'
        user.valid?
        expect(user.errors[:password_confirmation]).not_to include('deve estar igual à senha')
      end
    end

    context 'when password_confirmation does not match password' do
      it 'adds an error' do
        user.password_confirmation = 'wrongpassword'
        user.valid?
        expect(user.errors[:password_confirmation]).to include('não é igual a Password')
      end
    end
  end  
end
