source 'https://rubygems.org'

# Run `bundle config --global github.https true` on the server to quiet warnings

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.21.0'
# Use nested hstore to store serialized objects in Active Record hstore
gem 'nested-hstore', '~> 0.1.2'

# Use SCSS for stylesheets
# Locked in at beta1 release because major release doesn't play nice with compass-rails yet
gem 'sass-rails', '~> 5.0.7'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 4.1'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.2.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.3.1'
# Use modernizr for browser feature detection
gem 'modernizr-rails', '~> 2.7.0'
# Use the NYU Libraries assets gem
gem 'nyulibraries_stylesheets', github: 'NYULibraries/nyulibraries_stylesheets', tag: 'v1.1.2'
gem 'nyulibraries_templates', github: 'NYULibraries/nyulibraries_templates', tag: 'v1.2.2'
gem 'nyulibraries_institutions', github: 'NYULibraries/nyulibraries_institutions', tag: 'v1.0.3'
gem 'nyulibraries_javascripts', github: 'NYULibraries/nyulibraries_javascripts', tag: 'v1.0.0'
gem 'nyulibraries_errors', github: 'NYULibraries/nyulibraries_errors', tag: 'v1.1.0'
# Use higher version of Compass CSS framework for sprites, etc.
gem 'compass-rails', '~> 3.1'

# Use the NYU Libraries deploy gem
gem 'formaggio', github: 'NYULibraries/formaggio', tag: 'v1.7.2'

# Used for determining which institution is in play
gem 'institutions', '~> 0.1.3'

# Use devise for our user model
gem 'devise', '~> 4.4.3'

# Use Ox for parsing XML
gem 'ox', '~> 2.9.0'

# Use omniauth for logging in from multiple providers
gem 'omniauth', '~> 1.8.1'
# Shibboleth strategy
gem 'omniauth-shibboleth', '~> 1.3.0'
# Twitter strategy
gem 'omniauth-twitter', '~> 1.4.0'
# GitHub strategy
gem 'omniauth-aleph', '~> 1.0.0'
gem 'omniauth-ldap', '~> 1.0.4'

gem 'font-awesome-rails', '~> 4'

# Use doorkeeper as our OAuth 2.0 provider
gem 'doorkeeper', '~> 4.4.2'
# Manually include responders to maintain respond_with & respond_to functionality
gem 'responders', '~> 2.0'

# Figs for configuration
gem 'figs', '~> 2.1'

# Taking this up to >= 0.13 breaks other dependencies
gem 'faraday', '~> 0.12.0'
gem 'faraday_middleware', '~> 0.12'

gem 'dalli', '~> 2.7.8'

gem 'bootsnap', '~> 1.3.1', require: false

gem 'addressable', '~> 2.5.2'

gem 'sentry-raven', '~> 2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Development gems
group :development do
  gem 'better_errors', '~> 2', platform: :ruby
  gem 'binding_of_caller', '~> 0.8', platform: :ruby
  gem 'listen'
  gem 'web-console', '>= 3.3.0'
end

# Testing gems
group :test, :cucumber do
  # Coveralls for testing coverage
  gem 'coveralls', '~> 0.8', require: false
  gem 'cucumber-rails', '~> 1.6', require: false
  gem 'selenium-webdriver', '~> 3'
  gem 'pickle', '~> 0.5'
  gem 'database_cleaner', '~> 1.7'
  gem 'vcr', '~> 4'
  gem 'webmock', '~> 3'
  # Rspec as the test framework
  gem 'rspec-rails', '~> 3.7'
  # Phantomjs for headless browser testing
  gem 'phantomjs', '>= 1.9.7'
  gem 'poltergeist', '~> 1'
  # Use json_spec to do rspec tests with JSON
  gem 'json_spec', '~> 1.1'
  gem 'rspec-its', '~> 1.2'
  gem 'faker', '~> 1'
  # allows for assigns and assert_template testing in Rails 5
  gem 'rails-controller-testing'
  gem 'capybara-screenshot'
end

group :test, :cucumber, :development do
  # Use Puma as the app server for testing and local development
  gem 'puma', '~> 3.12'

  gem 'pry-rails'
  gem 'byebug'
  # Use factory_bot for creating models
  gem 'factory_bot_rails', '~> 4.11'
end
