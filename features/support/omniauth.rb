# Use OmniAuth test mode when tagged
# This allows us to create reliable integration tests across environments
Around('@omniauth_test') do |scenario, block|
  OmniAuth.config.test_mode = true
  block.call
  OmniAuth.config.test_mode = false
end
