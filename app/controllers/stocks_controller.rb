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
  end

  def new
    @stock = Stock.new
  end

  def create
    @stock = Stock.new(stock_params)
    if @stock.save
      # Associate with Broker
      UserStock.create(user_id: current_user.id, stock_id: @stock.id)
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
