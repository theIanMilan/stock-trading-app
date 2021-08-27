class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  def after_sign_in_path_for(*)
    # override devise's same method
    if current_user.role? :admin
      rails_admin_path
    else
      dashboard_path
    end
  end

  def after_sign_out_path_for(*)
    new_session_path
  end
end
