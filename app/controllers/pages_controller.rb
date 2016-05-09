class PagesController < ApplicationController
  # use this controller to handle all static pages
  skip_before_filter :deny_access
  def front
    redirect_to home_path if current_user
  end
end
