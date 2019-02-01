require_relative 'boot'

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

if ENV['DOCKER'] && !Rails.env.test?
  require 'figs'
  # Don't run this initializer on travis.
  Figs.load(stage: Rails.env)
end

module Login
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.enforce_available_locales = true

    # Mailer default URL options
    config.action_mailer.default_url_options = { protocol: "https", host: "login.library.nyu.edu" }

    # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
    config.force_ssl = true

    # It seems like images are included by default only from app/assets folder
    # So in order to get images from shared assets we do this
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)

    # Rails 5 options:
    config.eager_load_paths << Rails.root.join('lib')

    config.action_controller.per_form_csrf_tokens = true
    config.action_controller.forgery_protection_origin_check = true

    Raven.configure do |config|
      config.dsn = ENV['SENTRY_DSN']
    end

    # output rails logs to unicorn; thanks to https://gist.github.com/soultech67/67cf623b3fbc732291a2
    if ENV['DOCKER'] && !Rails.env.test?
      config.force_ssl = false

      config.unicorn_logger = Logger.new(STDOUT)
      config.unicorn_logger.formatter = Logger::Formatter.new
      config.logger = ActiveSupport::TaggedLogging.new(config.unicorn_logger)

      config.logger.level = Logger.const_get('INFO')
      config.log_level = ENV['UNICORN_LOG_LEVEL']&.to_sym || :info
    end
  end
end
