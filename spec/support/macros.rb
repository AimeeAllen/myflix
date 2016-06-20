def no_logged_in_user
  session[:user_id] = nil
end

def log_in_a_user
  @user = Fabricate(:user)
  session[:user_id] = @user.id
end
