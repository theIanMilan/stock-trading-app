class Order < ApplicationRecord
  belongs_to :user
  belongs_to :stock
  scope :buy_transactions, -> { where transaction_type: 'buy' }
  scope :sell_transactions, -> { where transaction_type: 'sell' }

  validate :total_buy_price_cannot_exceed_user_balance
  validate :sell_quantity_cannot_exceed_user_stocks
  validate :buy_quantity_cannot_exceed_max_stock_quantity

  enum transaction_type: { buy: 0, sell: 1 }

  private

  def total_buy_price_cannot_exceed_user_balance
    user = User.find(user_id)

    return unless transaction_type == 'buy' && (user.balance < price * quantity)

    errors.add(:price, 'Insufficient funds with the given price and quantity.')
  end

  def sell_quantity_cannot_exceed_user_stocks
    user = User.find(user_id)

    return unless transaction_type == 'sell' && quantity > user.user_stocks.find_by(stock_id)[:total_shares]

    errors.add(:quantity, 'Insufficient user stocks to sell.')
  end

  def buy_quantity_cannot_exceed_max_stock_quantity
    user = User.find(user_id)

    return unless transaction_type == 'buy' && quantity > user.quantity

    errors.add(:quantity, 'Buy quantity cannot exceed total available stock quantity.')
  end
end
