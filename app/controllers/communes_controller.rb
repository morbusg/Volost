class CommunesController < ApplicationController
  #cache_sweeper :commune_sweeper, :only => [:create, :update, :destroy]

  before_filter :init_categories, :only => [:index,:new,:edit]
  before_filter :init_commune, :except => [:index, :create]
  before_filter :verify_view_permission, :only => [:show]
  before_filter :verify_modify_permission, :only => [:edit, :update, :destroy, :order]
  before_filter :verify_create_permission, :only => [:new, :create]
  before_filter :breadcrumbs, :only => [:new, :edit, :show]

  # Cache index only if either not logged in (only public categories visible),
  # or user is admin (all categories visible, links to edit).
  # Otherwise no caching since visible categories depend on:
  # a) if user is active
  # b) categories the user belongs to.
  # One possibility is to cache on session[:user], but that's... meh
  #caches_action :index, :cache_path => :index_cache_path.to_proc, :layout => false,
  #  :if => :index_cache_conditions.to_proc

  # Cache show path needs to include the pagination pages
  #caches_action :show, :cache_path => :show_cache_path.to_proc, :layout => false

  def index
  end

  def show
    @topics = @commune.topics.paginate(:include => :latest,
                                       :per_page => TOPICS_PER_PAGE,
                                       :total_entries => @commune.topics_count,
                                       :page => params[t(:page, :scope => :routes)])
  end

  def new; end

  def create
    Commune.create!(params[:commune]) ? redirect_to(root_path) : render(:action => :new)
  end

  def edit; end

  def update
    @commune.update_attributes(params[:commune]) ? redirect_to(root_path) : render(:action => :edit)
  end

  def destroy
    @commune.destroy && redirect_to(root_path) || render(:text => "Error", :status => 400)
  end

  def order
    if ['move_lower', 'move_higher', 'move_to_top', 'move_to_bottom'].include?(params[:direction])
      @commune.send(params[:direction])
      redirect_to(root_path)
    end
  end

  private
  # Initialization {{{
  def init_categories
    if logged_in?
      @categories = Category.all(:include => {:communes => :latest},
                                 :order => :position)
    else
      @categories = Category.public.all(:include => {:communes => :latest},
                                        :order => :position)
    end
  end

  def init_commune
    @commune = Commune.find_or_initialize_by_id(params[:id])
  end
  # }}}

  # Access control {{{
  def verify_view_permission
    raise(SecurityError) unless(current_user.can_view?(@commune))
  end

  def verify_modify_permission
    raise(SecurityError) unless(current_user.can_modify?(@commune))
  end

  def verify_create_permission
    raise(SecurityError) unless(current_user.can_create?(@commune))
  end
  # }}}

  # Caching {{{
  def index_cache_conditions
    !logged_in? or current_user.admin?
  end

  def index_cache_path
    "communes/admin_#{current_user.admin?}"
  end

  def show_cache_path
    "communes/#{params[:id]}/#{params[t(:page, :scope => :routes)]}"
  end
  # }}}

end
