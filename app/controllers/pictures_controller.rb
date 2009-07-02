class PicturesController < ApplicationController
  before_filter :init
  before_filter :verify_view_permission

  def index
    @pictures = @user.pictures
  end

  private
  def init
    @user = User.find(params[:user_id])
  end

  def verify_view_permission
    # TODO Pictures could be in a non-accessible topic, pm, etc.
    logged_in?
  end
end
