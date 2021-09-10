require 'rails_helper'

RSpec.describe UserStock, type: :model do
  subject(:user_stock) { build(:user_stock, user: user, stock: stock) }

  let!(:stock) { create(:stock, :p10_q100) }
  let!(:user) { create(:user, :buyer) }

  context 'with valid attributes' do
    it { is_expected.to be_valid }

    it 'is valid when total_shares is 0' do
      user_stock.total_shares = 0
      expect(user_stock).to be_valid
    end

    it 'is valid when average_price is 0' do
      user_stock.average_price = 0
      expect(user_stock).to be_valid
    end
  end

  context 'with invalid attributes' do
    it 'is not valid without total_shares' do
      user_stock.total_shares = nil
      expect(user_stock).not_to be_valid
    end

    it 'is not valid when total_shares is negative' do
      user_stock.total_shares = -1
      expect(user_stock).not_to be_valid
    end

    it 'is not valid without an average_price' do
      user_stock.average_price = nil
      expect(user_stock).not_to be_valid
    end

    it 'is not valid when average_price is negative' do
      user_stock.average_price = -1
      expect(user_stock).not_to be_valid
    end
  end
end
