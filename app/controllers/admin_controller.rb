class AdminController < ApplicationController
  layout "admin"
 
  before_filter :check_permissions
 
  def index
    @users = User.all
    @categories = Category.all
    @image_count = Image.all.count
  end

private

  def check_permissions
    unless user_logged_in?
      redirect_to log_in_path
    end
  end

end
