class Order < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  scope :buy_transactions, -> { where transaction_type: 'buy' }
  scope :sell_transactions, -> { where transaction_type: 'sell' }

  validates :price, numericality: { greater_than: 0 }
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :transaction_type, inclusion: { in: %w[buy sell] }
  validate :total_buy_price_cannot_exceed_user_balance
  validate :sell_quantity_cannot_exceed_user_stocks
  validate :buy_quantity_cannot_exceed_max_stock_quantity

  enum transaction_type: { buy: 0, sell: 1 }

  after_commit :match_and_execute_order, on: %i[create update]

  private

  def match_and_execute_order
    case transaction_type
    when 'buy'
      # Match to sell orders
      @matching_orders = stock.orders.sell_transactions.where('price <= ?', price).order('price ASC')
    when 'sell'
      # Match to buy orders
      @matching_orders = stock.orders.buy_transactions.where('price >= ?', price).order('price DESC')
    end

    # Execute transaction if match occurs
    process_order if quantity.positive? && @matching_orders.count.positive?
  end

  def process_order
    UserStock.skip_callback(:create, :after, :add_price_and_quantity) # Temporarily skip user_stock callback
    # Finds record else Create New empty user_stock if user has no associated stock
    @user_stock = user.user_stocks.find_or_create_by(stock_id: stock_id) do |us|
      us.average_price = 0
      us.total_shares = 0
    end

    @user2_order = @matching_orders.first
    @user2 = @user2_order.user
    # Finds record else Create New empty user_stock if user2 has no associated stock
    @user2_stock = @user2.user_stocks.find_or_create_by(stock_id: stock_id) do |us|
      us.average_price = 0
      us.total_shares = 0
    end
    UserStock.set_callback(:create, :after, :add_price_and_quantity)

    Order.transaction do
      case transaction_type
      when 'buy'
        # Determine price & quantity
        # Price and Quantity is min of user and user2
        match_price    = [price, @user2_order.price].min
        match_quantity = [quantity, @user2_order.quantity].min
        total_value = match_price * match_quantity

        # Transfer Balance
        transfer_balance(user, @user2, total_value) if user.sufficient_balance?(total_value)

        # Recalculate user_stocks (total shares and avg price)
        transfer_stocks(@user_stock, @user2_stock, match_quantity, total_value)

        # Create Transaction Record
        create_transaction(user, @user2, stock, match_price, match_quantity)
      when 'sell'
        # Determine price & quantity
        # Price is max of user and user2
        # Quantity is min of user and user2
        match_price    = [price, @user2_order.price].max
        match_quantity = [quantity, @user2_order.quantity].min
        total_value = match_price * match_quantity

        # Transfer Balance
        transfer_balance(@user2, user, total_value) if @user2.sufficient_balance?(total_value)

        # Recalculate user_stocks (total shares and avg price)
        transfer_stocks(@user2_stock, @user_stock, match_quantity, total_value)

        # Create Transaction Record
        create_transaction(@user2, user, stock, match_price, match_quantity)
      end

      # Update and Destroy Orders
      update_quantity_of_orders(self, @user2_order, match_quantity)
      stock.update_last_price(match_price)
      destroy_zero_quantity_orders
      # Due to after_save callback, this will process next unfulfilled and matching orders until there are no more matches
    end
  end

  def transfer_balance(buyer, seller, total_value)
    buyer.change_balance_by(- total_value)
    seller.change_balance_by(+ total_value)
  end

  def transfer_stocks(buyer_stock, seller_stock, quantity, total_value)
    buyer_stock.recalculate_user_stock(+ quantity, + total_value)
    seller_stock.recalculate_user_stock(- quantity, - total_value)
  end

  def update_quantity_of_orders(current_order, counterpart_order, decrease_in_quantity)
    counterpart_order.update_columns(quantity: counterpart_order.quantity - decrease_in_quantity) # rubocop:disable Rails/SkipsModelValidations
    counterpart_order.destroy if counterpart_order.quantity.zero?
    current_order.update(quantity: current_order.quantity - decrease_in_quantity)
  end

  def create_transaction(buyer, seller, stock, price, quantity)
    TransactionRecord.create!(stock_id: stock.id,
                              buyer_id: buyer.id,
                              broker_id: seller.id,
                              price: price,
                              quantity: quantity)
  end

  def destroy_zero_quantity_orders
    return unless quantity.zero?

    destroy
  end

  # Custom Validations
  def total_buy_price_cannot_exceed_user_balance
    return if price.nil? || quantity.nil?
    return unless transaction_type == 'buy' && (user.balance < (price * quantity))

    errors.add(:price, 'Insufficient funds with the given price and quantity.')
    errors.add(:quantity, 'Insufficient funds with the given price and quantity.')
  end

  def sell_quantity_cannot_exceed_user_stocks
    return unless transaction_type == 'sell' && quantity > user.user_stocks.find_by(stock_id: stock_id)[:total_shares]

    errors.add(:quantity, 'Insufficient user stocks to sell.')
  end

  def buy_quantity_cannot_exceed_max_stock_quantity
    return if quantity.nil?
    return unless transaction_type == 'buy' && quantity > stock.quantity

    errors.add(:quantity, 'Buy quantity cannot exceed total available stock quantity.')
  end
end
