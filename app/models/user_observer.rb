class UserObserver < ActiveRecord::Observer

  def arb
    @arb ||= ActionController::Base.new
  end

  def after_save(user)
    arb.expire_fragment %r{users/.*}
  end

  def after_destroy(user)
    arb.expire_fragment %r{users/.*}
  end

end
