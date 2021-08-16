class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    # override devise's same method
    if current_user.role? :admin
      rails_admin_path
    else
      dashboard_path
    end
  end
end
