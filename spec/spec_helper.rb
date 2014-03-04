# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
SHIBBOLETH_ENV = {
  'Shib-Application-ID' => 'application-id',
  'Shib-Authentication-Instant' => '2014-02-19T14:17:28.747Z',
  'Shib-Authentication-Method' => 'urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport',
  'Shib-AuthnContext-Class' => 'urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport',
  'Shib-Identity-Provider' => 'https://idp.shibboleth.edu/idp/shibboleth',
  'Shib-Session-ID' => 'session-id',
  'Shib-Session-Index' => 'session-index',
  'displayName' => 'Dev Eloper',
  'email' => 'dev.eloper@nyu.edu',
  'entitlement' => 'urn:mace:nyu.edu:entl:lib:eresources;urn:mace:incommon:entitlement:common:1',
  'givenName' => 'Dev',
  'nyuidn' => '1234567890',
  'sn' => 'Eloper',
  'uid' => 'dev1'
}
# Wear coveralls
require 'coveralls'
Coveralls.wear_merged!('rails')
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'database_cleaner'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # Include Factory Girl convenience methods
  config.include FactoryGirl::Syntax::Methods

  # Include Devise test helpers
  config.include Devise::TestHelpers, type: :controller

  # Include User Macros
  config.include UserMacros, type: :controller

  # Include Login Macros
  config.extend LoginMacros, type: :controller

  # Include Doorkeeper Macros
  config.extend DoorkeeperMacros, type: :controller

  # Include OmniAuth Hash Macros
  config.include OmniAuthHashMacros

  # Include Shibboleth Macros
  config.include ShibbolethMacros, type: :request

  config.before(:suite) do
    # Run factory girl lint before the suite
    FactoryGirl.lint

    # Startout by trucating all the tables
    DatabaseCleaner.clean_with :truncation
    # Then use transactions to roll back other changes
    DatabaseCleaner.strategy = :transaction
  end

  config.around(:each) do |example|
    DatabaseCleaner.start
    example.run
    DatabaseCleaner.clean
  end
end
