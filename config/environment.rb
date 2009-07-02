RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')
Rails::Initializer.run do |config|
  config.gem "haml"
  config.gem "BlueCloth"
  config.gem "rubypants"
  config.gem "authlogic"
  config.frameworks -= [ :active_resource, :action_mailer ]
  config.time_zone = 'UTC'
  config.i18n.default_locale = :fi
  config.action_controller.session_store = :active_record_store
  config.active_record.timestamped_migrations = false
  config.active_record.observers = [:message_observer, :commune_observer,
    :category_observer, :user_observer]
end

ActionController::Base.cache_store = :file_store, "tmp/cache"

Haml::Template.options[:format] = :html5
WillPaginate::ViewHelpers.pagination_options[:next_label] = "»"
WillPaginate::ViewHelpers.pagination_options[:previous_label] = "«"

unauth_logfile = File.open("#{RAILS_ROOT}/log/unauth.log", 'a')
unauth_logfile.sync = true
UNAUTH_LOG = UnauthLogger.new(unauth_logfile)

LOGO = "svg/volost.svg"
VOLOST_NAME = I18n.t(:your_volost_name)
VOLOST_DESCR = I18n.t(:your_volost_description)
TEXT_BROWSERS = %r(Lynx|Links)
REPLIES_PER_PAGE = 30
TOPICS_PER_PAGE = 30
CONFIRM_TXT = I18n.t(:are_you_sure?)
ZONES = ActiveSupport::TimeZone::ZONES.map {|z|
      [[z.formatted_offset, z.tzinfo].join(' '), z.name]}.sort
