class VotesController < ApplicationController
  
  before_filter :init

  def create
    @vote = Vote.new(params[:vote])
    @user.votes << @vote
    redirect_to :back
  end

  private
  def init
    @user = User.find(params[:user_id])
    if not logged_in? or @user.votes.include?(params[:vote][:choice_id])
      raise SecurityError
    end
  end

end
