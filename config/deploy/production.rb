# PRODUCTION-specific deployment configuration
# please put general deployment config in config/deploy.rb
role :app, "198.61.197.94" 
role :web, "198.61.197.94"
role :db, "198.61.197.94", :primary => true
set :branch, "master"

set :rails_env, :production
