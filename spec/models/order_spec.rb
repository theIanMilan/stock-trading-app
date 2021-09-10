require 'rails_helper'

RSpec.describe Order, type: :model do
  subject(:order) { build(:order, :buying, user: buyer, stock: stock) }

  let!(:stock) { create(:stock, :p10_q100) }
  let!(:buyer) { create(:user, :buyer) }
  let!(:user) { create(:user, :broker) }

  context 'with valid attributes' do
    it { is_expected.to be_valid }

    it 'is valid when quantity is 0' do
      order.quantity = 0
      expect(order).to be_valid
    end
  end

  context 'with invalid attributes' do
    it 'is not valid without a quantity' do
      order.quantity = nil
      expect(order).not_to be_valid
    end

    it 'is not valid when quantity is negative' do
      order.quantity = -1
      expect(order).not_to be_valid
    end

    it 'is not valid without a price' do
      order.price = nil
      expect(order).not_to be_valid
    end

    it 'is not valid when price is 0' do
      order.price = 0
      expect(order).not_to be_valid
    end

    it 'is not valid when price is negative' do
      order.price = -1
      expect(order).not_to be_valid
    end

    it 'is not valid without a transaction_type' do
      order.transaction_type = nil
      expect(order).not_to be_valid
    end

    it 'is not valid when total buy price exceeds user balance' do
      order.price = 999.99
      order.quantity = 9_999
      expect(order).not_to be_valid
    end

    it 'is not valid when total buy quantity exceeds max stock quantity' do
      order.quantity = 9_999_999
      expect(order).not_to be_valid
    end
  end

  context 'with sell order' do
    subject(:sell_order) { create(:order, user: user, stock: stock) }

    it 'is not valid when sell quantity exceeds user_stocks' do
      create(:user_stock, user: user, stock: stock) # Create associated user_stock
      sell_order.quantity = 999_999
      expect(sell_order).not_to be_valid
    end
  end
end
