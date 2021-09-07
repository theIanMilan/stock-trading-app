require 'rails_helper'

RSpec.describe 'OrderMatchings', type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:user)  { create(:user, :buyer) }

  let!(:user2) { create(:user, :broker) }
  let!(:stock) { create(:stock) }
  let!(:user_stock) do
    create(:user_stock, user: user2, stock: stock,
           average_price: stock.last_transaction_price,
           total_shares: stock.quantity)
  end
  let!(:order) do
    create(:order, user: user2,
           stock: stock,
           price: (user_stock.average_price + 1),
           quantity: user_stock.total_shares)
  end

  it 'buy order that matches sell order executes' do
    expect(order).to be_valid
  end
end
