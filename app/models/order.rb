class Order < ApplicationRecord
  belongs_to :user
  belongs_to :stock
  scope :buy_transactions, -> { where transaction_type: 'buy' }
  scope :sell_transactions, -> { where transaction_type: 'sell' }

  validate :total_buy_price_cannot_exceed_balance
  validate :order_quantity_cannot_exceed_max_stock_quantity

  enum transaction_type: { buy: 0, sell: 1 }

  private

  def total_buy_price_cannot_exceed_balance
    user = User.find(user_id)

    return unless transaction_type == 'buy' && (user.balance < price * quantity)

    errors.add(:price, 'Insufficient funds with the given price and quantity.')
  end

  def order_quantity_cannot_exceed_max_stock_quantity
    user = User.find(user_id)

    return unless quantity > user.quantity

    errors.add(:quantity, 'Order quantity cannot exceed total available stock quantity.')
  end
end
