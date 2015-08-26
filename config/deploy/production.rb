set :rails_env, "production"
set :branch, "master"

namespace :deploy do
  task :schema_load do
    run "cd #{latest_release}; RAILS_ENV=#{rails_env} bundle exec rake db:schema:load"
  end
end

before "deploy:migrations", "deploy:schema_load"
