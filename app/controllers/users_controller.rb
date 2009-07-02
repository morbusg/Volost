class UsersController < ApplicationController
  before_filter :init, :except => [:index]
  before_filter :verify_view_permission, :only => [:index, :show]
  before_filter :verify_create_permission, :only => [:new, :create]
  before_filter :verify_modify_permission, :except => [:index, :show, :new, :create]
  before_filter :additional_breadcrumbs, :only => [:new, :edit, :show, :index]

  #caches_action :index, :layout => false, :cache_path => :index_cache_path.to_proc

  def index
    @users = User.paginate(:page => params[t(:page, :scope => :routes)],
                           :order => :login,
                           :per_page => 50,
                           :include => :avatar)
  end

  def show
    #@favourites = @user.favourites.empty? ? [] : Topic.find(@user.favourites)
    #respond_to do |format|
    #  format.html
    #  format.js {render(:partial => 'users/user', :object => @user)}
    #end
  end

  def new
    @user.build_avatar
  end

  def edit
    @categories = Category.all(:conditions => {:public => false}).map {|c| [c.name,c.id]}
    @communes = Commune.all.map {|c| [c.title,c.id]}
    @user.build_avatar if @user.avatar.nil?
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    if current_user.admin?
      @user.admin = params[:user][:admin].to_i
      @user.active = params[:user][:active].to_i
      @user.designation = params[:user][:designation]
      @user.category_ids = params[:user][:category_ids]
      @user.commune_ids = params[:user][:commune_ids]
    end
    if @user.update_attributes(params[:user])
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy; @user.destroy; redirect_to :back; end

  def inactive; @users = User.inactive.all; end

  def toggle_active
    @user.toggle!(:active)
    redirect_to :back
  end

  def activate_all
    User.inactive.activate
    redirect_to :back
  end

  private
  def init; @user = User.find_or_initialize_by_id(params[:id]); end

  # Access control {{{
  def verify_view_permission
    return true
    #unless logged_in? or current_user.id == @user.id or current_user.active? or current_user.admin?
  end

  def verify_modify_permission
    raise(SecurityError) unless(current_user.admin? or current_user.id == @user.id)
  end

  def verify_create_permission
    # TODO black-listing, parsing, etc.
  end
  # }}}

  def additional_breadcrumbs
    breadcrumbs(@template.link_to(t(:users, :scope => :routes), users_path))
  end

  def index_cache_path
    "users/#{params[t(:page, :scope => :routes)]}"
  end

end
