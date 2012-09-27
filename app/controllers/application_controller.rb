class ApplicationController < ActionController::Base
  protect_from_forgery

  def user_logged_in?
    not session[:user_id].blank?
  end
  
  
  def connect_to_s3 
    AWS::S3::Base.establish_connection!(
      :access_key_id     => "AKIAI6O755TN7LMPDB3Q",
      :secret_access_key => "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"
    )
  end

end
