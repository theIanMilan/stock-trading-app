class StocksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  load_and_authorize_resource # CanCan authorization helper
  before_action :set_stock, only: %i[show]

  def index
    @stocks = Stock.all
  end

  # GET /stocks/1 or /stocks/1.json
  def show
    @orders = @stock.orders
    @buy_orders = @orders.buy_transactions
    @sell_orders = @orders.sell_transactions
  end

  def new
    @stock = Stock.new
  end

  def create
    @stock = Stock.new(stock_params)
    if @stock.save
      # Associate with Broker
      current_user.stocks << @stock
      # Update user_stocks
      current_user.user_stocks.where(stock_id: @stock)
                  .update(average_price: @stock.last_transaction_price, total_shares: @stock.quantity)
      flash.notice = 'Stock was successfully added.'
      redirect_to stock_path(@stock)
    else
      flash.alert = 'Failed: Error in adding Stock.'
    end
  end

  private

  def set_stock
    @stock = Stock.find(params[:id])
  end

  def stock_params
    params.require(:stock).permit(:ticker, :company_name, :quantity, :last_transaction_price)
  end
end
