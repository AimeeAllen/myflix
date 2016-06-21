def no_logged_in_user
  session[:user_id] = nil
end

def log_in_a_user
  @user = Fabricate(:user)
  session[:user_id] = @user.id
end

# feature spec macros
def sign_in(user=nil)
  visit login_path
  user ||= Fabricate(:user)
  fill_in "Email Address", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end
