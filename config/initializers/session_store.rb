# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cache_store, key: '_login_session'

ActionController::Base.new.write_fragment("CACHE_TEST_KEY", "VALID")
