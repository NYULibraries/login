require 'formaggio/capistrano'
set :recipient, "lib-webservices@nyu.edu"
set :app_title, "login"
set :keep_releases, 5
set :rvm_ruby_string, "2.5.1"
set :assets_gem, ["nyulibraries_stylesheets.git", "nyulibraries_javascripts.git"]
set :new_relic_environments, ["none"]
