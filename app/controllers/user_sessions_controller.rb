class UserSessionsController < ApplicationController

  layout "admin"

  def new
  end

  def create
    @user = User.authenticate(params[:name], params[:password])

    if @user
      session[:user_id] = @user.id
      redirect_to admin_index_url, :notice => "Logged In!"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged Out!"
  end
end
