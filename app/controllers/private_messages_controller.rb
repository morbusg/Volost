class PrivateMessagesController < ApplicationController
  before_filter :init
  before_filter :verify_view_permission, :only => [:index, :show]
  before_filter :verify_create_permission, :only => [:new, :create]
  before_filter :verify_modify_permission, :only => [:destroy]

  def index
    @pms = @user.received_private_messages
  end

  def show
  end

  def create
    @pm = @user.sent_private_messages.new(params[:private_message])
    @pm.author = @user.login
    if @user.sent_private_messages << @pm
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    @pm = @user.received_private_messages.find(params[:id])
    @pm.destroy
    redirect_to :back
  end

  private
  def init
    @user = User.find(params[:user_id])
  end
  
  def verify_view_permission
    raise(SecurityError) unless(current_user.id == @user.id)
  end

  def verify_create_permission
    raise(SecurityError) unless(current_user.id == @user.id)
  end

  def verify_modify_permission
    raise(SecurityError) unless(current_user.id == @user.id)
  end
end
