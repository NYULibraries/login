require 'coveralls'
Coveralls.wear_merged!('rails')

# Require and include helper modules
# in feature/support/helpers and its subdirectories.
Dir[Rails.root.join("features/support/helpers/**/*.rb")].each do |helper|
  require helper
  helper_name = "LoginFeatures::#{helper.camelize.demodulize.split('.').first}"
  Cucumber::Rails::World.send(:include, helper_name.constantize)
end

# Configure Capybara
Capybara.configure do |config|
  config.app_host = 'https://dev.login.library.nyu.edu'
  config.default_driver = :selenium
end

