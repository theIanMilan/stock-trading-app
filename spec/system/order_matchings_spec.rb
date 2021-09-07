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

  it 'same quantity buy/sell orders destroys both orders' do
    # Seller
    user2 = create(:user, :broker)
    stock = create(:stock, :p10_q100)
    create(:user_stock, user: user2, stock: stock)
    create(:order, user: user2, stock: stock)

    # Buyer
    user = create(:user, :buyer)
    create(:order, :buying, user: user, stock: stock)
    expect(Order.count).to eq(0)
  end

  it '1 75Q buy/ 2 50Q sell order destroys buy order' do
    # Seller
    user2 = create(:user, :broker)
    stock = create(:stock, :p10_q100)
    create(:user_stock, user: user2, stock: stock)
    create(:order, user: user2, stock: stock, quantity: 50)
    create(:order, user: user2, stock: stock, quantity: 50)

    # Buyer
    user = create(:user, :buyer)
    create(:order, :buying, user: user, stock: stock, quantity: 75)
    expect(Order.count).to eq(1)
    expect(Order.last.quantity).to eq(25)
    expect(Order.last.transaction_type).to eq('sell')
  end

  it '2 50Q buy/ 1 75Q sell order destroys sell order' do
    # Seller
    user2 = create(:user, :broker)
    stock = create(:stock, :p10_q100)
    create(:user_stock, user: user2, stock: stock)
    create(:order, user: user2, stock: stock, quantity: 75)

    # Buyer
    user = create(:user, :buyer)
    create(:order, :buying, user: user, stock: stock, quantity: 100)
    expect(Order.count).to eq(1)
    expect(Order.last.quantity).to eq(25)
    expect(Order.last.transaction_type).to eq('buy')
  end

  it 'no order execution when sell/buy orders exist but do not match' do
    # Seller
    user2 = create(:user, :broker)
    stock = create(:stock, :p10_q100)
    create(:user_stock, user: user2, stock: stock)
    create(:order, user: user2, stock: stock, price: 1_000, quantity: 75)

    # Buyer
    user = create(:user, :buyer)
    create(:order, :buying, user: user, stock: stock, price: 1, quantity: 100)
    expect(Order.count).to eq(2)
    expect(user.user_stocks.count).to eq(0)
  end
end
