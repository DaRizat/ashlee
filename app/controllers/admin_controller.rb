class AdminController < ApplicationController
  layout "admin"
 
  before_filter :check_permissions
 
  def index
    @users = User.all
    @categories = Category.all
    
    @category_hash = {}
  
    @categories.each do |category|
      @category_hash[category.name] = {
        :image_count => category.images.count,
        :featured_images => Image.where("category_id = ? AND feature =?", category.id, true)
      }
    end

    @image_count = Image.all.count
  end

private

  def check_permissions
    unless user_logged_in?
      redirect_to log_in_path
    end
  end

end
