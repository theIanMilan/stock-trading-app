class OrdersController < ApplicationController
  before_action :set_stock, only: %i[new create edit update destroy]
  before_action :set_order, only: %i[edit update destroy]
  append_after_action :match_and_execute_order, only: %i[create update]

  def new
    @order = current_user.orders.build
  end

  def edit; end

  def create
    @order = current_user.orders.build(order_params)
    @order[:stock_id] = @stock.id

    if @order.save
      flash.notice = 'Order was successfully added.'
      redirect_to stock_path(@stock)
    else
      flash.alert = 'Failed: Error in adding Order.'
    end
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to stock_orders_path, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  protected

  def match_and_execute_order
    @stock = Stock.find(@order.stock_id)

    case @order.transaction_type
    when 'buy'
      # Match to sell orders
      @matching_orders = @stock.orders.sell_transactions.where('price <= ?', @order.price).order('price ASC')
    when 'sell'
      # Match to buy orders
      @matching_orders = @stock.orders.buy_transactions.where('price >= ?', @order.price).order('price DESC')
    end

    # Execute transaction if match occurs
    process_order if @order.quantity.positive? && @matching_orders.count.positive?
  end

  def process_order
    @user = @order.user
    @stock = Stock.find(@order.stock_id)
    @user_stock = @user.user_stocks.find_by(stock_id: @order.stock_id)
    if @user_stock.nil?
      # Create New empty user_stock if user has no associated stock
      @user_stock = @user.user_stocks.new(stock_id: @stock,
                                          user_id: @user,
                                          average_price: 0.0,
                                          total_shares: 0)
      @user_stock.save
    end

    @user2_order = @matching_orders.first
    @user2 = @user2_order.user
    @user2_stock = @user2.user_stocks.find_by(stock_id: @order.stock_id)
    if @user2_stock.nil?
      # Create New empty user_stock if user2 has no associated stock
      @user2_stock = @user2.user_stocks.new(stock_id: @stock,
                                            user_id: @user2_stock,
                                            average_price: 0.0,
                                            total_shares: 0)
      @user2_stock.save
    end

    Order.transaction do
      case @order.transaction_type
      when 'buy'
        # Determine price & quantity
        # Price and Quantity is min of user and user2
        match_price    = [@order.price, @user2_order.price].min
        match_quantity = [@order.quantity, @user2_order.quantity].min
        total_value = match_price * match_quantity

        # Transfer Balance
        transfer_balance(@user, @user2, total_value) if @user.sufficient_balance?(total_value)

        # Recalculate user_stocks (total shares and avg price)
        transfer_stocks(@user_stock, @user2_stock, match_quantity, total_value)

        # Create Transaction Record
        create_transaction(@user, @user2, @stock, match_price, match_quantity)
      when 'sell'
        # Determine price & quantity
        # Price and Quantity is max of user and user2
        match_price    = [@order.price, @user2_order.price].max
        match_quantity = [@order.quantity, @user2_order.quantity].max
        total_value = match_price * match_quantity

        # Transfer Balance
        transfer_balance(@user2, @user, total_value) if @user2.sufficient_balance?(total_value)

        # Recalculate user_stocks (total shares and avg price)
        transfer_stocks(@user2_stock, @user_stock, match_quantity, total_value)

        # Create Transaction Record
        create_transaction(@user2, @user, @stock, match_price, match_quantity)
      end

      flash[:notice] = 'Order successfully executed.'
      # Update and Destroy Orders
      update_quantity_of_orders(@order, @user2_order, match_quantity)
      # Due to after_save callback, this will process next unfulfilled and matching orders until there are no more matches
      # redirect_to dashboard_path
      # byebug
      # return
    end
    # Block will only be executed if above transaction fails
    # flash[:alert] = 'Fatal error encountered while procesing your order. Please try again.'
    # redirect_back(fallback_location: @stock)
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
    transaction = TransactionRecord.new(stock_id: stock,
                                        buyer_id: buyer,
                                        broker_id: seller,
                                        price: price,
                                        quantity: quantity)
    transaction.save
  end

  private

  def set_stock
    @stock = Stock.find(params[:stock_id])
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:transaction_type,
                                  :price,
                                  :quantity)
  end
end
