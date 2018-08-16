RSpec.configure do |config|
  # Include Factory Girl convenience methods
  config.include FactoryBot::Syntax::Methods

  FactoryBot::SyntaxRunner.send(:include, OmniAuthHashMacros)

  # Include Devise test helpers
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view

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

  # Include helpers for JSON
  config.include JsonSpec::Helpers
end
