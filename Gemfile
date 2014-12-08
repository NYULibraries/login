source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.0.9'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.17.1'
# Use nested hstore to store serialized objects in Active Record hstore
gem 'nested-hstore', '~> 0.0.5'
gem 'activerecord-postgres-hstore', '0.7.6' # 0.7.7 Has a PG syntax error in a rake task that causes this to fail

# Use SCSS for stylesheets
gem 'sass-rails',   '>= 5.0.0.beta1'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 3.1.0'
# Use modernizr for browser feature detection
gem 'modernizr-rails', '~> 2.7.0'
# Use the Compass CSS framework for sprites, etc.
gem 'compass-rails', '~> 2.0.0'
# Use mustache for templating
# Fix to 0.99.4 cuz 0.99.5 broke my shit.
gem 'mustache', '0.99.4'
gem 'mustache-rails', github: 'josh/mustache-rails', :require => 'mustache/railtie'
# Use the NYU Libraries assets gem
gem 'nyulibraries-assets', github: 'NYULibraries/nyulibraries-assets', tag: 'v4.1.4'
# gem 'nyulibraries-assets', path: '/apps/nyulibraries-assets'

# Use the NYU Libraries deploy gem
gem 'formaggio', github: 'NYULibraries/formaggio', tag: 'v1.0.0'
# gem 'nyulibraries-deploy', path: '/apps/nyulibraries-deploy'

# Used for determining which institution is in play
gem 'institutions', '~> 0.1.3'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 2.2.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# Use devise for our user model
gem 'devise', '~> 3.2.0'

# Use Ox for parsing XML
gem 'ox', '~> 2.1.0'

# Use omniauth for logging in from multiple providers
gem 'omniauth', '~> 1.2.2'
# Shibboleth strategy
gem 'omniauth-shibboleth', '~> 1.1.2'
# Passive Shibboleth strategy
gem 'omniauth-shibboleth-passive', '~> 0.1.0'
# Facebook strategy
gem 'omniauth-facebook', '~> 2.0.0'
# Twitter strategy
gem 'omniauth-twitter', '~> 1.0.1'
# GitHub strategy
gem 'omniauth-github', '~> 1.1.2'
gem 'omniauth-aleph', '~> 0.1.3'
gem 'omniauth-ldap', '~> 1.0.4'

gem 'font-awesome-rails', '~> 4.2.0'

# Use doorkeeper as our OAuth 2.0 provider
gem 'doorkeeper', '~> 1.4.0'

# Figs for configuration
gem 'figs', '~> 2.0.0'

gem 'faraday', '~> 0.9.0'
gem 'faraday_middleware', '~> 0.9.1'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# New Relic performance monitoring
# gem 'newrelic_rpm', '~> 3.8.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Development and testing gems
group :development, :test, :cucumber do
  # Rspec as the test framework
  gem 'rspec-rails', '~> 2.14.1'
  # Phantomjs for headless browser testing
  gem 'phantomjs', '>= 1.9.7'
  gem 'poltergeist', '~> 1.5.1'
  # Use factory girl for creating models
  gem 'factory_girl_rails', '~> 4.4.1'
  # Use pry-debugger as the REPL and for debugging
  gem 'pry-byebug', '~> 2.0.0'
  gem 'pry-remote', '~> 0.1.8'
  # Use json_spec to do rspec tests with JSON
  gem 'json_spec', '~> 1.1.2'
end

# Development gems
group :development do
  gem 'better_errors', '~> 2.0.0', platform: :ruby
  gem 'binding_of_caller', '~> 0.7.2', platform: :ruby
end

# Testing gems
group :test, :cucumber do
  # Coveralls for testing coverage
  gem 'coveralls', '~> 0.7.0', require: false
  gem 'cucumber-rails', '~> 1.4.1', require: false
  gem 'selenium-webdriver', '~> 2.43.0'
  gem 'pickle', '~> 0.4.11'
  gem 'database_cleaner', '~> 1.3.0'
  gem 'vcr', '~> 2.9.3'
  gem 'webmock', '>= 1.8.0', '< 1.16'
end
