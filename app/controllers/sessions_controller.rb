class SessionsController < ApplicationController
  skip_before_filter :deny_access, only: [:new, :create]

  def new
    redirect_to home_path if current_user
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:success] = "Welcome #{@user.fullname}"
      redirect_to home_path
    else
      flash.now[:danger] = "Invalid Email or Password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have logged out"
    redirect_to root_path
  end
end
