class AvatarsController < ApplicationController
  before_filter :init
  before_filter :verify_create_permission, :only => [:new, :create]
  before_filter :verify_modify_permission, :only => [:edit, :update, :destroy]

  def destroy
    @user.avatar.destroy
    redirect_to :back
  end

  private
  def init
    raise(SecurityError) unless(logged_in?)
    @user = User.find(params[:user_id])
  end

  def verify_create_permission
    raise(SecurityError) unless(current_user.id == @user.id or current_user.admin?)
  end

  def verify_modify_permission
    raise(SecurityError) unless(current_user.id == @user.id or current_user.admin?)
  end

end
