require 'coveralls'
Coveralls.wear_merged!('rails')

# Require and include helper modules
# in feature/support/helpers and its subdirectories.
Dir[Rails.root.join("features/support/helpers/**/*.rb")].each do |helper|
  require helper
  helper_name = "LoginFeatures::#{helper.camelize.demodulize.split('.').first}"
  Cucumber::Rails::World.send(:include, helper_name.constantize)
end
# High level of coupling between factories and spec tests. Must re-do factories
# to be compatible with all tests.
require Rails.root.join("spec/support/omni_auth_hash_macros.rb")
Cucumber::Rails::World.send(:include, OmniAuthHashMacros)
