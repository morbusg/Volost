module CommunesHelper

  def render_directions(item)
    return unless current_user.can_modify?(item)
    retval = []
    [['move_to_top', image_submit_tag("svg/top.svg")],
      ['move_higher', image_submit_tag("svg/up.svg")],
      ['move_lower', image_submit_tag("svg/down.svg")],
      ['move_to_bottom', image_submit_tag("svg/bottom.svg")]].each {|dir,symb|
      retval << button(symb, :method => :put,
                       :action => url_for(:controller => item.class.to_s.tableize,
                                          :action => :order,
                                          :id => item.id,
                                          :direction => dir))}
      return retval
  end

  def reply_pages(topic)
    return if topic.replies_count <= REPLIES_PER_PAGE
    retval = []
    (2..(topic.replies_count / REPLIES_PER_PAGE) + 1).to_a.each do |nr|
      retval << link_to(nr, topic_path(topic, t(:page, :scope => :routes) => nr))
      # don't create extra page
      break if (nr * REPLIES_PER_PAGE) == topic.replies_count
    end
    retval.size > 5 && retval = (retval.slice(0, 2) + retval.slice(-2, 2)).insert(2, '&hellip;')
    content_tag(:aside, retval.join(' '))
  end

end
