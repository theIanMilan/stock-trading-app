class OrdersController < ApplicationController
  before_action :set_stock, only: %i[new create edit update destroy]
  before_action :set_order, only: %i[edit update destroy]
  after_save :match_and_execute_order

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
    @stock = Stock.find(stock_id)

    case transaction_type
    when 'buy'
      # Match to sell orders
      @matching_orders = @stock.orders.sell_transactions.where('price <= ?', price).order('price ASC')
    when 'sell'
      # Match to buy orders
      @matching_orders = @stock.orders.buy_transactions.where('price >= ?', price).order('price DESC')
    end

    # Execute transaction while match occurs
    process_order while @matching_orders.count != 0 && quantity != 0
  end

  def process_order
    @stock = Stock.find(stock_id)

    Order.transaction do
      total_cost = price * quantity
      @user_stock = user.user_stocks.find_by(stock_id: stock_id)
      @order_counterpart = @matching_orders.first
      @user_counterpart = @order_counterpart.user

      case transaction_type
      when 'buy'
        current_user if current_user.sufficient_balance?(total_cost)
      when 'sell'
        @user_counterpart.user if @user_counterpart.sufficient_balance?(total_cost)
      end
    end
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
