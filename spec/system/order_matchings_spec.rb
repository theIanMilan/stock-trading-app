require 'rails_helper'

RSpec.describe 'OrderMatchings', type: :system do
  before do
    driven_by(:rack_test)
  end

  # # Initialize Buyer
  # let!(:user)  { create(:user, :buyer) }

  # # Initialize Seller
  # let!(:user2) { create(:user, :broker) }
  # let!(:stock) { create(:stock, :p10_q1000) }
  # let!(:user_stock) { create(:user_stock, user: user2, stock: stock) }
  # let!(:seller_order) { create(:order, user: user2, stock: stock) }

  it 'buy order that matches sell order executes' do
    # Seller
    user2 = create(:user, :broker)
    stock = create(:stock, :p10_q1000)
    create(:user_stock, user: user2, stock: stock)
    create(:order, user: user2, stock: stock)

    # Buyer
    user = create(:user, :buyer)
    create(:order, :buying, user: user, stock: stock)
    expect(Order.count).to eq(0)
  end
end
