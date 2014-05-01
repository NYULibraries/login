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
  # config.app_host = 'https://dev.login.library.nyu.edu'
  config.app_host = 'https://login.dev'
end

require 'capybara/poltergeist'
if ENV['IN_BROWSER']
  # On demand: non-headless tests via Selenium/WebDriver
  # To run the scenarios in browser (default: Firefox), use the following command line:
  # IN_BROWSER=true bundle exec cucumber
  # or (to have a pause of 1 second between each step):
  # IN_BROWSER=true PAUSE=1 bundle exec cucumber
  Capybara.default_driver = :selenium
  AfterStep do
    sleep (ENV['PAUSE'] || 0).to_i
  end
else
  # DEFAULT: headless tests with poltergeist/PhantomJS
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(
      app,
      window_size: [1280, 1024]#,
      #debug:       true
    )
  end
  Capybara.default_driver    = :poltergeist
  Capybara.javascript_driver = :poltergeist
end
