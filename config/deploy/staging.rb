set :rails_env, "staging"
set(:branch, ENV["GIT_BRANCH"].gsub(/remotes\/origin\//,"")) unless exists?(:branch)
