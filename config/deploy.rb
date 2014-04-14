require 'nyulibraries/deploy/capistrano'
<<<<<<< HEAD
set :recipient, "web.services@library.nyu.edu"
set :app_title, "login"
=======
require 'figs'
# Load up our figs, again
Figs.load(stage: fetch(:rails_env))
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
set(:scm_username, ENV['DEPLOY_SCM_USERNAME'])
set(:app_path, ENV['DEPLOY_PATH'])
set(:user, ENV['DEPLOY_USER'])
set(:puma_ports, nil)
set(:deploy_to, "#{fetch(:app_path)}#{fetch(:application)}")

Figs.env.deploy_servers.each_with_index do |deploy_server, index|
  primary_flag = (index === 1)
  server deploy_server, :app, :web, :db, primary: primary_flag
end
>>>>>>> 8d86d0f3706cb78612f1f9c58e0c1ad128407f01
