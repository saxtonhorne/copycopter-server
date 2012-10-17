role :app, "198.101.222.217"
role :web, "198.101.222.217"
role :db, "198.101.222.217", :primary => true
# role :db, "localhost", :primary => true

set :rails_env, :staging
