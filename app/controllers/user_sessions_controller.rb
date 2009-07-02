class UserSessionsController < ApplicationController
  #protect_from_forgery :except => [:create, :destroy] # FIXME: Error without this

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      #unless self.current_user.ips.include?(request.remote_ip)
      #  self.current_user.update_attribute('ips', request.remote_ip) 
      #end

      #session[:seen_at] = self.current_user.seen_at
      #self.current_user.update_attribute('seen_at', Time.now)
      redirect_to root_path
    else
      flash[:error] = t(:error_logging_in)
      redirect_to root_path
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to root_path
  end

end
