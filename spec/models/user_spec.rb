require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it 'is valid with valid attributes' do
    expect(user).to be_valid
  end

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
end
