class ApplicationController < ActionController::Base
  protect_from_forgery

  def user_logged_in?
    not session[:user_id].blank?
  end

end
