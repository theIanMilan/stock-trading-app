require 'rails_helper'

RSpec.describe Stock, type: :model do
  subject(:stock) { build(:stock) }

  context 'with valid attributes' do
    it { is_expected.to be_valid }
  end

  context 'with invalid attributes' do
    it 'is valid with valid attributes' do
      expect(stock).to be_valid
    end

    it 'is not valid with duplicate ticker' do
      create(:stock, ticker: 'AAA')
      expect(build(:stock, ticker: 'AAA')).not_to be_valid
    end

    it 'is not valid without a ticker' do
      stock.ticker = nil
      expect(stock).not_to be_valid
    end

    it 'is not valid without a company_name' do
      stock.company_name = nil
      expect(stock).not_to be_valid
    end

    it 'is not valid without a last_transaction_price' do
      stock.last_transaction_price = nil
      expect(stock).not_to be_valid
    end

    it 'is not valid when last_transaction_price is 0' do
      stock.last_transaction_price = 0
      expect(stock).not_to be_valid
    end

    it 'is not valid when last_transaction_price is negative' do
      stock.last_transaction_price = -1
      expect(stock).not_to be_valid
    end

    it 'is not valid without a quantity' do
      stock.quantity = nil
      expect(stock).not_to be_valid
    end

    it 'is not valid when quantity is 0' do
      stock.quantity = 0
      expect(stock).not_to be_valid
    end

    it 'is not valid when quantity is negative' do
      stock.quantity = -1
      expect(stock).not_to be_valid
    end
  end
end
