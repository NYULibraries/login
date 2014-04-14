source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.0.3'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.17.1'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 3.1.0'

# Use modernizr for browser feature detection
gem "modernizr-rails", "~> 2.7.0"

# Use the Compass CSS framework for sprites, etc.
gem "compass-rails", "~> 1.1.3"

# Use mustache for templating
# Fix to 0.99.4 cuz 0.99.5 broke my shit.
gem "mustache", "0.99.4"
# gem "mustache-rails", "~> 0.2.3", :require => "mustache/railtie"
gem "mustache-rails", github: "josh/mustache-rails", require: "mustache/railtie"

# Use the NYU Libraries assets gem
# gem "nyulibraries-assets", git: "git://github.com/NYULibraries/nyulibraries-assets.git", tag: 'v2.0.1'
gem "nyulibraries-assets", git: "git://github.com/NYULibraries/nyulibraries-assets.git", branch: 'development-login'
# gem "nyulibraries-assets", path: "/Users/dalton/Documents/workspace/nyulibraries-assets"

# Use the NYU Libraries deploy gem
gem "nyulibraries-deploy", git: "git://github.com/NYULibraries/nyulibraries-deploy.git"# , tag: 'v3.2.5'

# Used for determining which institution is in play
gem "institutions", "~> 0.1.3"

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 2.2.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.0'

# Use devise for our user model
gem 'devise', '~> 3.2.0'

# Use Ox for parsing XML
gem "ox", "~> 2.1.0"

# Use omniauth for logging in from multiple providers
gem "omniauth", "~> 1.2.0"
# Shibboleth strategy
gem "omniauth-shibboleth", "~> 1.1.1"
# Passive Shibboleth strategy
gem "omniauth-shibboleth-passive", "~> 0.1.0"
# Facebook strategy
gem "omniauth-facebook", "~> 1.6.0"
# Twitter strategy
gem "omniauth-twitter", "~> 1.0.1"
# GitHub strategy
gem "omniauth-github", "~> 1.1.1"
gem "omniauth-aleph", "~> 0.1.0"
gem "omniauth-ldap", "~> 1.0.4"

# Use doorkeeper as our OAuth 2.0 provider
gem "doorkeeper", "~> 1.0.0"

# Figs for configuration
gem "figs", "~> 1.2.0"

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# New Relic performance monitoring
gem "newrelic_rpm", "~> 3.7.0"

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Development and testing gems
group :development, :test do
  # Rspec as the test framework
  gem "rspec-rails", "~> 2.14.0"
  # Phantomjs for headless browser testing
  gem "phantomjs", ">= 1.9.0"
  # Use factory girl for creating models
  gem "factory_girl_rails", "~> 4.4.0"
  # Use pry-debugger as the REPL and for debugging
  gem 'pry-debugger', '~> 0.2.2'
end

# Development gems
group :development do
  gem "better_errors", "~> 1.1.0", platform: :ruby
  gem "binding_of_caller", "~> 0.7.0", platform: :ruby
end

# Testing gems
group :test do
  # Coveralls for testing coverage
  gem 'coveralls', "~> 0.7.0", require: false
  gem 'cucumber-rails', '~> 1.4.0', require: false
  gem 'selenium-webdriver', '~> 2.41.0'
  gem 'pickle', '~> 0.4.11'
  gem 'database_cleaner', '~> 1.2.0'
end
