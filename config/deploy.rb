require 'nyulibraries/deploy/capistrano'
set :recipient, "web.services@library.nyu.edu"
set :app_title, "login"
# Not using RailsConfig, so don't do anything
namespace :rails_config do
  task :set_variables do
  end
end
namespace :rails_config do
  task :set_servers do
  end
end
set(:app_settings, true)
set(:scm_username, ENV['LOGIN_SCM_USERNAME'])
set(:app_path, ENV['LOGIN_APP_PATH'])
set(:user,ENV['LOGIN_USER'])
set(:puma_ports, nil)
set(:deploy_to, "#{fetch :app_path}#{fetch :application}")
server ENV['LOGIN_PRIMARY_SERVER'], :app, :web, :db, :primary => true
