class UsersController < ApplicationController
  skip_before_filter :deny_access
  def new
    @user = User.new()
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "You have successfully registered"
      redirect_to login_path
    else
      render 'new'
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :fullname)
  end
end
