class RepliesController < ApplicationController
  #cache_sweeper :reply_sweeper, :only => [:create, :update, :destroy]

  before_filter :init
  before_filter :verify_modify_permission, :only => [:edit, :update, :destroy]
  before_filter :verify_create_permission, :only => [:new, :create]
  before_filter :additional_breadcrumbs, :only => [:new, :edit]

  def show
    redirect_to topic_path(@topic, t(:page, :scope => :routes).to_sym => (@topic.replies.index(@reply).to_i/REPLIES_PER_PAGE+1),
                           :anchor => "article_#{@reply.id}")
  end

  def new
    4.times {@reply.pictures.build}
    respond_to do |format|
      format.html {render :template => 'replies/_form.haml'}
      format.js {render :update do |page|
        page.insert_html :bottom, "article_#{@topic.id}", :partial => 'replies/form'
        page << "$$('nav a:last-child').invoke('hide');"
        page['reply_body'].focus
      end }
    end
  end

  def create
    @reply = @topic.replies.build(params[:reply]) do |r|
      cu = current_user
      r.commune_id, r.author, r.user_id = @topic.commune_id, cu.login, cu.id
    end
    @topic.replies << @reply ? redirect_to(@reply) : render(:action => :new)
    # rjs render :update do |page|
    #   page.insert_html :bottom, xxx, :partial => @reply
    #   page[:new_reply].reset
    #   page[:previewPane].replace_html ''
  end

  def edit
    4.times {@reply.pictures.build}
    @topics = @commune.topics
    respond_to do |format|
      format.html {render :template => 'replies/edit.haml'}
      format.js {render :update do |page|
        page.replace_html "article_#{@reply.id}", :partial => 'replies/form'
        page << "$$('nav a:last-child').invoke('hide');"
      end
      }
    end
  end

  def update
    respond_to do |format|
      format.html {
        @reply.update_attributes(params[:reply]) ? redirect_to(@reply) : render(:action => :edit)
      }
      format.js {render(:update) do |page|
        page["article_#{@reply.id}"].replace_html :partial => @reply
      end
      }
    end
  end

  def destroy
    @reply.destroy
    respond_to do |format|
      format.html {redirect_to(:back)}
      format.js {render :update do |page|
        page["article_#{@reply.id}"].remove
      end
      }
    end
  end

  private
  def init
    if params[:commune_id]
      @commune = Commune.find(params[:commune_id])
      @topic = @commune.topics.find(params[:topic_id])
      @reply = @topic.replies.find_or_initialize_by_id(params[:id])
    elsif params[:topic_id]
      @topic = Topic.find(params[:topic_id])
      @commune = @topic.commune
      @reply = @topic.replies.find_or_initialize_by_id(params[:id])
    else
      @reply = Reply.find_or_initialize_by_id(params[:id])
      @topic = @reply.topic
      @commune = @topic.commune
    end
  end

  def verify_modify_permission
    raise(SecurityError) unless(current_user.can_modify?(@reply))
  end

  def verify_create_permission
    raise(SecurityError) unless(current_user.can_create?(@reply))
  end

  def additional_breadcrumbs
    breadcrumbs(@topic, @commune)
  end

end
