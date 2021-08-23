require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) do
    described_class.new(email: 'emailemail@example.com',
                        password: 'p3assw0rd',
                        role: 'buyer')
  end

  it 'is valid with valid attributes' do
    expect(user).to be_valid
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
