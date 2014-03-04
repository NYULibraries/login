require 'coveralls'
Coveralls.wear_merged!('rails')

# Require and include helper modules
# in feature/support/helpers and its subdirectories.
Dir[Rails.root.join("features/support/helpers/**/*.rb")].each do |f|
  require f
  module_constant = f.camelize.demodulize.split('.').first.constantize
  Cucumber::Rails::World.send(:include, module_constant)
end
