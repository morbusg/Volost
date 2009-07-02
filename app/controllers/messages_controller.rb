class MessagesController < ApplicationController
  before_filter :init_user_messages, :only => :index

  def index
  end

  def recent
    @messages = Message.find(:all,
                             :conditions => ['created_at > ?', current_user.last_request_at])
    #render :partial => 'shared/message', :collection => @messages, :layout => true
  end

  def quote
    # TODO: split to both topics_controller and replies_controller for scoping etc.
    message = Message.find(params[:id])
    @topic = message.respond_to?(:topic) ? message.topic : message
    @commune = @topic.commune
    @reply = @topic.replies.build
    @bdy = "\n>**#{message.user[:login]} #{t(:wrote)}:**  \n"
    message.body.each_line('') { |l| @bdy << l.gsub(/^/,'>') }
    @bdy << "\n\n"
    respond_to do |format|
      format.html {
        @reply.body = @bdy
        render :template => 'replies/_form.haml', :object => @reply
      }
      format.js {render :update do |page|
        # FIXME: keeps piling up even if removing content
        # Also: crap
        page << "if (!($('reply_body'))) {"
        page.insert_html :bottom, "article_#{@topic.id}", :partial => 'replies/form'
        page << "}"
        page.insert_html :bottom, 'reply_body', @bdy
        page['reply_body'].focus
        page << "$$('nav a:last-child').invoke('hide');"
      end }
    end
  end

  def init_user_messages
    @user = User.find(params[:user_id])
    if logged_in?
      @messages = @user.messages.paginate(:conditions => ['type != ?', 'PrivateMessage'],
                                          :page => params[t(:page, :scope => :routes)],
                                          :total_entries => @user.messages_count)
    else
      public_categories = Category.public.all(:select => :id)
      public_communes = Commune.all(:conditions =>
                                    ["category_id IN (?)", public_categories],
                                    :select => :id) 
      @messages = @user.messages.all(:conditions =>
                                     ["commune_id IN (?)", public_communes]).
                                       paginate(:page => params[t(:page, :scope => :routes)],
                                                :total_entries => @user.messages_count)
    end
    # .delete_if {|msg|
      #msg.type == "PrivateMessage" or
      #!current_user.can_view?(msg)}
    #}.paginate(:page => params[t(:page, :scope => :routes)], :per_page => 50)
  end

end
