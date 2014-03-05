require 'figs'
# Don't run this initializer on travis.
Rails.application.config.before_initialize do
  Figs.load(stage: Rails.env) unless ENV['TRAVIS']
end
