# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper

  class PaginatedLinks < WillPaginate::LinkRenderer
    def initialize
      @gap_marker = '&hellip;'
    end

    def page_link(page, text, attributes = {})
      @template.link_to text, url_for(page)
    end

    def page_span(page, text, attributes = {})
      text
    end
  end

  #def track_topic(topic)
  #  return if not logged_in?
  #  owner = "user_#{current_user.id}"
  #  tracker ||= (YAML.load(cookies[owner]) rescue Hash.new )
  #  tracker["topic_#{topic.id}"]= { :count => topic.replies_count, :seen_at => Time.now }
  #  cookies[owner] = tracker.to_yaml
  #end

  #def unread_count(topic)
  #  tracker = YAML.load(cookies["user_#{current_user.id}"]) rescue return
  #  return if tracker["topic_#{topic.id}"].nil?
  #  retval = topic.replies_count - tracker["topic_#{topic.id}"][:count]
  #  return [retval, "new"[]].join(' ') unless retval == 0
  #end

  def author_class(user)
    return 'admin' if user.admin?
    return 'moderator' if user.moderator?
    return nil
  end

  def render_avatar(user)
    return if user.avatar.nil?
    image_tag(user.avatar.public_filename,
              :author => user_path(user),
              :alt => "#{user.login} avatar")
  end

  def link_to_message(message)
    #return unless current_page?(:controller => t(:messages, :scope => :routes).to_sym)
    link_to(message.title,
      { :controller => message.class.to_s.tableize,
        :action => :show,
        :id => message.id } )
  end

  def link_to_delete(item)
    #return unless logged_in? and current_user.can_modify?(item)
    button(image_submit_tag("svg/recycle.svg", :alt => t(:remove), :title => t(:remove)),
           :method => :delete,
           :action => url_for(:controller => item.class.to_s.tableize,
                              :action => :destroy,
                              :id => item.id))
  end

  def link_to_edit(item)
    return unless logged_in? and current_user.can_modify?(item)
    item_class = item.respond_to?(:replies) ? nil : 'remote'
    link_to(image_tag("svg/edit.svg", :alt => t(:edit), :title => t(:edit)),
            { :controller => item.class.to_s.tableize,
              :action => :edit,
              :id => item.id },
            :class => item_class)
    #button(image_submit_tag("svg/edit.svg", :alt => t(:edit), :title => t(:edit)),
    #       :method => :get,
    #       :action => url_for(:controller => item.class.to_s.tableize,
    #                          :action => :edit,
    #                          :id => item.id))
  end

  def link_to_split(message)
    #return unless message.respond_to?(:topic)
    #return unless logged_in? and current_user.can_modify?(@commune)
    button(image_submit_tag("svg/split.svg", :alt => t(:split), :title => t(:split)),
           :method => :put,
           :action => split_topic_path(message.topic_id, t(:chosen) => message.id))
  end

  def link_to_toggle_locked(message)
    #return unless message.respond_to?(:replies)
    #return unless logged_in? and current_user.can_modify?(@commune)
    button(image_submit_tag("svg/locked_#{message.locked?}.svg", :alt => t(:toggle_locked),
                           :title => t(:toggle_locked)),
           :action => toggle_locked_topic_path(message))
  end

  def link_to_toggle_sticky(message)
    #return unless message.respond_to?(:replies)
    #return unless logged_in? and current_user.can_modify?(@commune)
    button(image_submit_tag("svg/sticky_#{message.sticky?}.svg", :alt => t(:toggle_sticky),
                           :title => t(:toggle_sticky)),
           :action => toggle_sticky_topic_path(message))
  end

  def link_to_quote(message)
    return if !logged_in? or message.locked? or !current_user.active?
    link_to(image_tag("svg/quote.svg", :alt => t(:quote), :title => t(:quote)),
            quote_message_path(message), :class => 'remote')
    #button(image_submit_tag("svg/quote.svg", :alt => t(:quote), :title => t(:quote)),
    #       :method => :get,
    #       :action => quote_message_path(message))
  end

  def render_controls(message)
    retval = []
    #retval << link_to_delete(message)
    #retval << link_to_split(message)
    #retval << link_to_toggle_locked(message)
    #retval << link_to_toggle_sticky(message)
    retval << link_to_edit(message)
    retval << link_to_quote(message)
    return content_tag('aside', retval)
    #return false
  end

  #def topic_css_class(topic) # {{{
  #  topic_class = [cycle('even', 'odd')]
  #  topic_class << 'locked' if topic.locked?
  #  topic_class << 'sticky' if topic.sticky?
  #  topic_class << 'favourite' if topic.favourite?(current_user)
  #  topic_class.join(' ')
  #end # }}}

  def control(stuff)
    #return unless current_user.can_create?(stuff)
    content_for :control, stuff
  end

  def link_to_pm(user)
    return if not logged_in?
    return if current_user.id == user.id
    link_to(image_tag("svg/bubble.svg", :alt => t(:send_private_message),
                      :title => t(:send_private_message)),
                      new_user_private_message_path(current_user,
                                                    :receiver_id => user.id))
    #button(image_submit_tag("svg/bubble.svg", :title => t(:send_private_message)),
    #      :method => :get,
    #      :action => new_user_private_message_path(current_user,
    #                                              :receiver_id => user.id))
  end

  def button(content, options={})
    options[:class] = 'remote'
    options[:method] ||= :put

    tags = ''
    unless options[:method] == :get
      tags << (tag(:input, {:type => 'hidden', :name => 'authenticity_token',
                   :value => form_authenticity_token}) +
               tag(:input, {:type => 'hidden', :name => '_method',
                   :value => options[:method]}))
    end

    [:delete, :put].include?(options[:method]) && options[:method] = :post

    content_tag(:form, content + tags, options)

  end

  def location(*stuff)
    content_for :title, strip_links(stuff.join(" &rarr; ")).gsub(/\& /,'&amp; ')
    content_for :crumbs, stuff.join(" &rarr; ").gsub(/\& /,'&amp; ')
  end

  def paginate(collection)
    will_paginate(collection, :param_name => t(:page, :scope => :routes), :container => nil, 
                  :renderer => PaginatedLinks)
  end

  def render_topic_options
    retval = []
    retval << link_to_function(image_tag("svg/preview.svg", :title => t(:preview)),
                               "$$('fieldset:last-of-type').invoke('toggle')")
    retval << link_to_function(image_tag("svg/poll.svg", :title => t(:poll)),
                               "$$('fieldset:first-of-type').invoke('toggle')")
    retval << link_to_function(image_tag("svg/attach.svg", :title => t(:pictures)),
                               "$$('fieldset:nth-of-type(2)').invoke('toggle')")
    return retval.join(' ')
  end

  def choice_percentage(topic, choice)
    return 0 if choice.votes_count == 0
    ((choice.votes_count.to_f / topic.votes.count.to_f) * 100).to_i
  end

  def parse_crumbs
    return if @crumbs.blank?

    retval = []

    @crumbs.each do |crumb|
      if crumb.respond_to?(:title)
        retval << link_to_unless_current(crumb.title, crumb)
      else
        retval << crumb
      end
    end

    [:edit, :new].include?(params[:action].to_sym) &&
      retval.push(t(params[:action], :scope => :routes))

    location(retval)
  end

  def link_to_new_commune
    return unless current_user.admin?
    link_to(image_tag("svg/new_commune.svg",
                      :title => t(:new_commune),
                      :alt => t(:new_commune)),
            new_commune_path)
  end

  def link_to_new_topic(commune)
    return unless current_user.can_create?(commune.topics.new)
    link_to(image_tag("svg/new_topic.svg",
                      :title => t(:new_topic),
                      :alt => t(:new_topic)),
            new_commune_topic_path(commune))
  end

  def link_to_new_reply(topic)
    return unless current_user.can_create?(topic.replies.new)
    link_to(image_tag("svg/new_reply.svg",
                      :title => t(:new_reply),
                      :alt => t(:new_reply)),
            new_topic_reply_path(topic),
            :class => 'remote')
  end

  def parse_controls
    # braindead *and* ugly. dodging caching issues here
    # => [link, [javascripts], stylesheets]
    retval = case "#{params[:controller]}/#{params[:action]}"
      when 'communes/index' : [link_to_new_commune, [], [] ]
      when 'communes/show'  : [link_to_new_topic(@commune), [], [] ]
      when 'topics/show'    : [link_to_new_reply(@topic),
        (current_user.can_create?(@reply) ? %w[prototype Hyphenator
        control.object.event control.textarea control.textarea.markdown showdown
        lowpro_mod application] : %w[Hyphenator]), "markdown_toolbar"]
      else [nil, nil, nil]
    end
    control(retval[0]) unless retval[0].blank?
    content_for(:head, javascript_include_tag(retval[1])) unless retval[1].blank?
    content_for(:head, stylesheet_link_tag(retval[2])) unless retval[2].blank?
  end

end
