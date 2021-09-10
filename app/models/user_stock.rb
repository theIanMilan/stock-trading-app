class UserStock < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  # validates :average_price, numericality: { greater_than_or_equal_to: 0 }
  # validates :total_shares, numericality: { greater_than_or_equal_to: 0 }

  def recalculate_user_stock(change_in_quantity, change_in_total_value)
    # Also destroys user_stock if final total shares is zero
    current_total_value = total_shares * average_price
    final_total_value = current_total_value + change_in_total_value
    final_total_shares = total_shares + change_in_quantity

    if final_total_shares.zero?
      destroy
    else
      update(total_shares: final_total_shares)
      update(average_price: final_total_value / final_total_shares)
    end
  end

  def stock
    Stock.find(stock_id)
  end
end
