# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  EXCEPTIONS_NOT_LOGGED = ['ActionController::UnknownAction',
                           'ActionController::RoutingError']

  helper :all # include all helpers, all the time
  helper_method :current_user, :logged_in?

  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :set_timezone

  rescue_from SecurityError, :with => :unauthorized # XXX: I've a feeling this is wrong

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  require_dependency 'user' # what is a anonymoususer?
  require_dependency 'message' # what is a topic? what is a reply?

  def set_timezone
    Time.zone = current_user.time_zone rescue 'UTC'
    # lang = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

  def unauthorized
    UNAUTH_LOG.info "Denied #{request.remote_ip} to #{request.method.to_s.upcase} #{request.path}"
    flash[:error] = t(:unauthorized)
    redirect_to root_path
  end

  def log_error(exc)
    super unless EXCEPTIONS_NOT_LOGGED.include?(exc.class.name)
  end

  def breadcrumbs(*objects)
    @current_object = "@#{params[:controller].singularize}"
    return unless instance_variable_defined?(@current_object)
    @current_object = eval(@current_object)
    @crumbs = @current_object.new_record? ? [] : [@current_object]
    objects.each {|obj| @crumbs.unshift(obj) }
    return @crumbs
  end

  private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = (UserSession.find || AnonymousUser.new)
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = (current_user_session && current_user_session.record)
  end

  def logged_in?
    current_user.respond_to?(:messages)
  end

end
