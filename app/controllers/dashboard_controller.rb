class DashboardController < ApplicationController
  def index
    @user_stocks = current_user.user_stocks
  end
end
