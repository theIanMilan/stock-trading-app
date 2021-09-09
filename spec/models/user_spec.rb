require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  context 'with valid attributes' do
    it { is_expected.to be_valid }

    it 'is valid when balance is 0' do
      user.balance = 0
      expect(user).to be_valid
    end
  end

  context 'with invalid attributes' do
    it 'is not valid with duplicate email' do
      create(:user, email: '1234NewEmail@example.com')
      expect(build(:user, email: '1234NewEmail@example.com')).not_to be_valid
    end

    it 'is not valid without an email' do
      user.email = nil
      expect(user).not_to be_valid
    end

    it 'is not valid without a password' do
      user.password = nil
      expect(user).not_to be_valid
    end

    it 'is not valid without a role' do
      user.role = nil
      expect(user).not_to be_valid
    end

    it 'is not valid without a username' do
      user.username = nil
      expect(user).not_to be_valid
    end

    it 'is not valid without a firstname' do
      user.firstname = nil
      expect(user).not_to be_valid
    end

    it 'is not valid without a lastname' do
      user.lastname = nil
      expect(user).not_to be_valid
    end

    it 'is not valid without a balance' do
      user.balance = nil
      expect(user).not_to be_valid
    end

    it 'is not valid when balance is negative' do
      user.balance = -1
      expect(user).not_to be_valid
    end
  end
end
