class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :deny_access

  helper_method :current_user

  def deny_access
    unless current_user
      flash[:error] = "Please sign in to take that action"
      redirect_to login_path
    end
  end

  def current_user
    if session[:user_id]
      User.find(session[:user_id])
    end
  end
end
