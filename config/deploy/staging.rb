set :rails_env, "staging"
set(:branch, ENV["GIT_BRANCH"].gsub(/origin\//,"")) unless exists?(:branch)
