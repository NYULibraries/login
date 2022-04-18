# Configure Capybara
require 'capybara-screenshot/cucumber' if ENV['SCREENSHOT_FAILURES']
Capybara.save_path = "/screenshots"

Capybara.default_max_wait_time = 30

def configure_selenium
  Capybara.register_driver :selenium do |app|
    options = ::Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-gpu')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--window-size=1280,1024')
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
    #capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    #  options: {
    #    args: %w(no-sandbox headless disable-gpu window-size=1280,1024 disable-dev-shm-usage disable-infobars)
    #  }
    #)

    #Capybara::Selenium::Driver.new(
    #  app,
    #  browser: :chrome,
    #  desired_capabilities: capabilities
    #)
  end
end

configure_selenium
Capybara.javascript_driver = :selenium
Capybara.default_driver = :selenium
Capybara.current_driver = :selenium

Capybara.server = :puma, { Silent: true }
Capybara.app_host = 'http://localhost:3000'
Capybara.server_port = 3000

ENV['FLAT_FILE'] = "spec/data/patrons-UTF-8.dat"
