class DashboardController < ApplicationController
  def index
    @user_stocks = current_user.user_stocks.all
  end
end
