class TopicsController < ApplicationController
  #cache_sweeper :topic_sweeper, :only => [:create, :update, :destroy]

  before_filter :init
  before_filter :verify_view_permission, :only => [:show]
  before_filter :verify_modify_permission, :except => [:index, :show, :new, :create]
  before_filter :verify_create_permission, :only => [:new, :create]
  before_filter :additional_breadcrumbs, :only => [:new, :edit, :show]

  # Cache show only if either not logged in (no controls visible),
  # or user is admin (all controls visible). Makes no sense.
  #caches_action :show, :cache_path => :show_cache_path.to_proc,
  #  :if => :show_cache_conditions.to_proc, :layout => false

  def index; redirect_to root_path; end

  def show
    @replies = @topic.replies.paginate(:page => params[t(:page, :scope => :routes)],
                                       :per_page => REPLIES_PER_PAGE,
                                       :total_entries => @topic.replies_count,
                                       :include => [{:user => :avatar}, :pictures])
    @reply = @topic.replies.build
  end

  def new
    4.times {@topic.pictures.build}
    4.times {@topic.choices.build}
  end

  def edit
    4.times {@topic.pictures.build}
    4.times {@topic.choices.build}
    @communes = Commune.all.delete_if {|commune| !current_user.can_view?(commune)}
    #respond_to do |format|
    #  format.html {render :template => 'topics/edit.haml'}
    #  format.js {render :update do |page|
    #    page.replace_html "article_#{@topic.id}", :partial => 'topics/form'
    #  end }
    #end
  end

  def create
    @topic = @commune.topics.new(params[:topic]) do |topic|
      topic.user_id, topic.author = current_user.id, current_user.login
    end
    @topic.save ? redirect_to(@topic) : render(:action => :new)
  end

  def update
    @topic.commune_id = params[:topic][:commune_id]
    @topic.update_attributes(params[:topic]) ? redirect_to(@topic) : render(:action => :edit)
  end

  def destroy
    @topic.destroy ? redirect_to(@commune) : render(:text => "Error", :status => 400)
  end

  def split # FIXME: this is crap. figure out some nicer way
    reply = @topic.replies.find(params[t(:chosen)])
    new_topic = @commune.topics.new

    new_topic.title       = "#{t(:split_from)} #{@topic.title}"
    new_topic.author      = reply.author
    new_topic.body        = reply.body
    new_topic.created_at  = reply.created_at
    new_topic.user_id     = reply.user_id

    reply.destroy
    new_topic.save(false)
    redirect_to(:back)
  end

  def toggle_locked
    @topic.toggle!(:locked)
    respond_to do |format|
      format.html {redirect_to(:back)}
      format.js
    end
  end

  def toggle_sticky
    @topic.toggle!(:sticky)
    respond_to do |format|
      format.html {redirect_to(:back)}
      format.js
    end
  end

  private
  def init
    if params[:commune_id]
      @commune = Commune.find(params[:commune_id])
      @topic = @commune.topics.find_or_initialize_by_id(params[:id])
    else
      @topic = Topic.find_or_initialize_by_id(params[:id])
      @commune = @topic.commune
    end
  end

  def verify_view_permission
    raise(SecurityError) unless(current_user.can_view?(@topic))
  end

  def verify_modify_permission
    raise(SecurityError) unless(current_user.can_modify?(@topic))
  end

  def verify_create_permission
    raise(SecurityError) unless(current_user.can_create?(@topic))
  end

  def show_cache_conditions
    !logged_in? or current_user.admin?
  end

  def show_cache_path
    "topics/#{params[:id]}/admin_#{current_user.admin?}_#{params[t(:page, :scope => :routes)]}"
  end

  def additional_breadcrumbs
    breadcrumbs(@commune)
  end

end
