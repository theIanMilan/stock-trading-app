require 'rails_helper'

RSpec.describe 'OrderMatchings', type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:buyer)  { create(:user, :buyer) }
  let!(:broker) { create(:user, :broker) }
  let!(:stock) { create(:stock, :p10_q100) }

  it 'no matching buy/sell orders creates no transaction' do
    create(:user_stock, user: broker, stock: stock)
    create(:order, user: broker, stock: stock, price: 1_000, quantity: 75)

    create(:order, :buying, user: buyer, stock: stock, price: 1, quantity: 100)
    expect(Order.count).to eq(2)
    expect(buyer.user_stocks.count).to eq(0)
    expect(TransactionRecord.count).to eq(0)
  end

  it 'same quantity buy/sell orders destroys both orders' do
    create(:user_stock, user: broker, stock: stock)
    create(:order, user: broker, stock: stock)

    create(:order, :buying, user: buyer, stock: stock)
    expect(Order.count).to eq(0)
  end

  it '2 sell orders (100Q) destroys 1 buy order (75Q)' do
    create(:user_stock, user: broker, stock: stock)
    create(:order, user: broker, stock: stock, quantity: 50)
    create(:order, user: broker, stock: stock, quantity: 50)

    create(:order, :buying, user: buyer, stock: stock, quantity: 75)
    expect(Order.count).to eq(1)
    expect(Order.last.quantity).to eq(25)
    expect(Order.last.transaction_type).to eq('sell')
  end

  it '1 sell order (100Q) destroys 2 buy order (75Q)' do
    create(:user_stock, user: broker, stock: stock)
    create(:order, user: broker, stock: stock, quantity: 100)

    create(:order, :buying, user: buyer, stock: stock, quantity: 70)
    create(:order, :buying, user: buyer, stock: stock, quantity: 5)
    expect(Order.count).to eq(1)
    expect(Order.last.quantity).to eq(25)
    expect(Order.last.transaction_type).to eq('sell')
  end

  it '2 buy orders (100Q) destroys 1 sell order (75Q)' do
    create(:user_stock, user: broker, stock: stock)
    create(:order, user: broker, stock: stock, quantity: 75)

    create(:order, :buying, user: buyer, stock: stock, quantity: 100)
    expect(Order.count).to eq(1)
    expect(Order.last.quantity).to eq(25)
    expect(Order.last.transaction_type).to eq('buy')
  end

  it '1 buy order (100Q) destroys 2 sell order (75Q)' do
    create(:user_stock, user: broker, stock: stock)
    create(:order, user: broker, stock: stock, quantity: 42)
    create(:order, user: broker, stock: stock, quantity: 33)

    create(:order, :buying, user: buyer, stock: stock, quantity: 100)
    expect(Order.count).to eq(1)
    expect(Order.last.quantity).to eq(25)
    expect(Order.last.transaction_type).to eq('buy')
  end
end
