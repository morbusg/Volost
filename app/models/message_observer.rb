class MessageObserver < ActiveRecord::Observer

  def arb
    @arb ||= ActionController::Base.new # NOTE: MVC VIOLATION!
  end

  def target_page(reply)
    target_page = (reply.topic.replies_count / REPLIES_PER_PAGE).to_s
    target_page =~ /1|0/ && target_page = '1?'
    return target_page
  end

  def before_save(msg)
    msg.respond_to?(:topic) && msg.title = msg.topic.title
  end

  def after_create(msg)
    if msg.respond_to?(:topic) or msg.respond_to?(:replies)
      msg.commune.update_attribute('latest_id', msg.id)
      arb.expire_fragment %r{communes/.*}
      arb.expire_fragment %r{communes/#{msg.commune_id}/.*}
    end
    if msg.respond_to?(:topic)
      msg.topic.update_attribute('latest_id', msg.id)
      arb.expire_fragment %r{topics/#{msg.topic_id}/.*#{target_page(msg)}.*}
    end
  end

  def after_update(msg)
    if msg.respond_to?(:topic)
      arb.expire_fragment %r{topics/#{msg.topic_id}/.*#{target_page(msg)}.*}
    end
  end

  def after_destroy(msg)
    if msg.id == msg.commune.latest_id
      arb.expire_fragment %r{communes/.*}
      arb.expire_fragment %r{communes/#{msg.commune_id}/.*}
      if msg.commune.topics_count == 1 # lé bizarro
        msg.commune.update_attribute('latest_id', nil)
      else
        msg.commune.update_attribute('latest_id', msg.commune.messages.first.id)
      end
    end

    if msg.respond_to?(:topic)
      if msg.id == msg.topic.latest_id
        arb.expire_fragment %r{topics/#{msg.topic_id}/.*#{target_page(msg)}.*}
        if msg.topic.replies_count == 1 # ditto
          msg.topic.update_attribute('latest_id', nil)
        else
          msg.topic.update_attribute('latest_id', msg.topic.replies.last.id)
        end
      end
    end
  end

end
