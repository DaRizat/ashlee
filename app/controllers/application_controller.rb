class ApplicationController < ActionController::Base
  protect_from_forgery

  def user_logged_in?
    not session[:user_id].blank?
  end
  
  
  def connect_to_s3 
    AWS::S3::Base.establish_connection!(
      :access_key_id     => ENV['ASHLEE_AWS_KEY'],
      :secret_access_key => ENV['ASHLEE_AWS_SECRET']
    )
  end

end
