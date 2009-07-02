class CategoriesController < ApplicationController
  #cache_sweeper :category_sweeper, :only => [:create, :update, :destroy]

  before_filter :init
  before_filter :verify_create_permission, :only => [:new, :create]
  before_filter :verify_modify_permission, :only => [:edit, :update, :destroy, :order]

  def new; end

  def edit; end

  def show; redirect_to root_path; end

  def create; Category.create(params[:category]); redirect_to :back; end

  def update
    @category.update_attributes(params[:category])
    redirect_to root_path
  end

  def destroy; @category.destroy; redirect_to root_path; end

  def order
    if ['move_lower', 'move_higher', 'move_to_top', 'move_to_bottom'].include?(params[:direction])
      @category.send(params[:direction])
      redirect_to(root_path)
    end
  end

  private
  def init; @category = Category.find_or_initialize_by_id(params[:id]); end

  def verify_create_permission
    raise(SecurityError) unless(current_user.admin?)
  end

  def verify_modify_permission
    raise(SecurityError) unless(current_user.admin?)
  end

end
