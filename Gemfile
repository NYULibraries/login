source 'https://rubygems.org'

# Run `bundle config --global github.https true` on the server to quiet warnings

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '=4.2.9'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.21.0'
# Use nested hstore to store serialized objects in Active Record hstore
gem 'nested-hstore', '~> 0.1.2'

# Use SCSS for stylesheets
# Locked in at beta1 release because major release doesn't play nice with compass-rails yet
gem 'sass-rails', '~> 5.0.6'
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
gem 'nyulibraries_stylesheets', github: 'NYULibraries/nyulibraries_stylesheets', tag: 'v1.0.5'
gem 'nyulibraries_templates', github: 'NYULibraries/nyulibraries_templates', tag: 'v1.1.2'
gem 'nyulibraries_institutions', github: 'NYULibraries/nyulibraries_institutions', tag: 'v1.0.3'
gem 'nyulibraries_javascripts', github: 'NYULibraries/nyulibraries_javascripts', tag: 'v1.0.0'
gem 'nyulibraries_errors', github: 'NYULibraries/nyulibraries_errors', tag: 'v1.0.1'
# Use higher version of Compass CSS framework for sprites, etc.
gem 'compass-rails', '~> 3.0.0'

# Use the NYU Libraries deploy gem
gem 'formaggio', github: 'NYULibraries/formaggio', tag: 'v1.7.2'

# Used for determining which institution is in play
gem 'institutions', '~> 0.1.3'

# Use devise for our user model
# # NOTE: upgrade to >4.4.2 when bugfix released on rubygems
# # see: https://github.com/plataformatec/devise/commit/64aad8b1383ac68f2d8cec21d3c69af684709931#diff-bafaaa60fc003e648eb4981c9add523e
gem 'devise', '~> 4.4.3'

# Use Ox for parsing XML
gem 'ox', '~> 2.9.0'

# Use omniauth for logging in from multiple providers
gem 'omniauth', '~> 1.8.1'
# Shibboleth strategy
gem 'omniauth-shibboleth', '~> 1.3.0'
# Facebook strategy
gem 'omniauth-facebook', '~> 4.0.0'
# Twitter strategy
gem 'omniauth-twitter', '~> 1.4.0'
# GitHub strategy
gem 'omniauth-aleph', '~> 1.0.0'
gem 'omniauth-ldap', '~> 1.0.4'

gem 'font-awesome-rails', '~> 4'

# Use doorkeeper as our OAuth 2.0 provider
# NOTE: factory_bot_rails fix needed before update to >4.3.1
# see issue: https://github.com/doorkeeper-gem/doorkeeper/issues/1043
gem 'doorkeeper', '~> 4.2.0'

# Figs for configuration
gem 'figs', '~> 2.1'

# Taking this up to 0.13 breaks other dependencies
gem 'faraday', '~> 0.12.0'
gem 'faraday_middleware', '~> 0.12'

gem 'dalli', '~> 2.7.7'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# New Relic performance monitoring
gem 'newrelic_rpm', '~> 4'
# Rollbar performance monitoring
gem 'rollbar', '~> 2'

# Development gems
group :development do
  gem 'better_errors', '~> 2', platform: :ruby
  gem 'binding_of_caller', '~> 0.8', platform: :ruby
end

# Testing gems
group :test, :cucumber do
  # Coveralls for testing coverage
  gem 'coveralls', '~> 0.8', require: false
  gem 'cucumber-rails', '~> 1.5', require: false
  gem 'selenium-webdriver', '~> 3'
  gem 'pickle', '~> 0.5'
  gem 'database_cleaner', '~> 1.6'
  gem 'vcr', '~> 4'
  gem 'webmock', '~> 3'
  # Rspec as the test framework
  gem 'rspec-rails', '~> 3.6'
  # Phantomjs for headless browser testing
  gem 'phantomjs', '>= 1.9.7'
  gem 'poltergeist', '~> 1'
  # Use factory_bot for creating models
  gem 'factory_bot_rails', '~> 4.8.2'
  # Use json_spec to do rspec tests with JSON
  gem 'json_spec', '~> 1.1'
  gem 'rspec-its', '~> 1.2'
  gem 'faker', '~> 1'
end

group :test, :cucumber, :development do
  gem 'pry', '~> 0'
  gem 'pry-remote', '~> 0'
end
