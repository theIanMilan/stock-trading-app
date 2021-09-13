class OrdersController < ApplicationController
  before_action :set_stock, only: %i[new create edit update destroy]
  before_action :set_order, only: %i[edit update destroy]

  def new
    @order = current_user.orders.build
    @disabled = if current_user.user_stocks.find_by(stock: @stock).nil?
                  ['sell']
                else
                  []
                end
  end

  def edit; end

  def create
    @order = current_user.orders.build(order_params)
    @order[:stock_id] = @stock.id
    @order_quantity_copy = @order.quantity

    if @order.save
      flash.notice = 'Order was successfully added.'
      # Check if transaction succeeded
      flash.notice = 'Order was successfully executed.' if @order.quantity != @order_quantity_copy
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
