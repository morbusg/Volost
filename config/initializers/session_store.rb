# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_commune_session',
  :secret      => '074490b986c25db14ecf7b9c56c10a83faed2a34f88c2bd04dd32be84b7cddb5b1feaf9bb00379d5031b9921397837ba552c1c170908686a0a2aacc278e28746'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
