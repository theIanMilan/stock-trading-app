require 'rails_helper'

RSpec.describe TransactionRecord, type: :model do
  subject(:transaction_record) { build(:transaction_record, buyer: buyer, broker: broker, stock: stock) }

  let!(:stock) { create(:stock, :p10_q100) }
  let!(:buyer) { create(:user, :buyer) }
  let!(:broker) { create(:user, :broker) }

  it { is_expected.to be_valid }

  context 'with invalid attributes' do
    it 'is not valid without a quantity' do
      transaction_record.quantity = nil
      expect(transaction_record).not_to be_valid
    end

    it 'is not valid when quantity is 0' do
      transaction_record.quantity = 0
      expect(transaction_record).not_to be_valid
    end

    it 'is not valid when quantity is negative' do
      transaction_record.quantity = -1
      expect(transaction_record).not_to be_valid
    end

    it 'is not valid without a price' do
      transaction_record.price = nil
      expect(transaction_record).not_to be_valid
    end

    it 'is not valid when price is 0' do
      transaction_record.price = 0
      expect(transaction_record).not_to be_valid
    end

    it 'is not valid when price is negative' do
      transaction_record.price = -1
      expect(transaction_record).not_to be_valid
    end
  end
end
