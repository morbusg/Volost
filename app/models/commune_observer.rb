class CommuneObserver < ActiveRecord::Observer

  def arb
    @arb ||= ActionController::Base.new
  end

  def after_save(commune)
    arb.expire_fragment %r{communes/.*}
    arb.expire_fragment %r{communes/#{commune.id}/.*}
  end

  def after_destroy(commune)
    arb.expire_fragment %r{communes/.*}
    arb.expire_fragment %r{communes/#{commune.id}/.*}
  end

end
