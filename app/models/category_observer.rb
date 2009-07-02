class CategoryObserver < ActiveRecord::Observer

  def arb
    @arb ||= ActionController::Base.new
  end

  def after_save(category)
    arb.expire_fragment %r{communes/.*}
  end

  def after_destroy(category)
    arb.expire_fragment %r{communes/.*}
  end

end
