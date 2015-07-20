require './config/env_git_branch'
set :rails_env, "staging"
set(:branch, env_git_branch)
