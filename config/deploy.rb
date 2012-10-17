# To deploy to either production or staging with a non default branch please use the following.
# staging: cap -s branch-$MY_BRANCH deploy
# production: cap -s branch-$MY_BRANCH production deploy
require 'bundler/capistrano'
require 'new_relic/recipes'
load 'deploy/assets'

set :application, "copycopter"
set :repository,  "git@github.com:saxtonhorne/copycopter-server"

set :scm, :git

set :use_sudo, false
set :user, "deploy"
set :group, "www-data"

set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache
set :deploy_env, 'production'
set :rails_env, :production

role :app, "copy.saxtonhorne.net" 
role :web, "copy.saxtonhorne.net"
role :db, "copy.saxtonhorne.net", :primary => true
set :branch, "master"

default_run_options[:pty] = true

# after "deploy:restart", "newrelic:notice_deployment"
after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  task :start do
    run "cd #{current_release} && bundle exec thin start -s 2 -d -a 127.0.0.1 -e #{rails_env}" 
  end

  task :restart do
    logger.important "Rolling restart will take a minute.\n" +
                     "Note that asset paths will change before the restart\n" +
                     "finishes, assets may not route correctly for a few seconds.\n"

    run "cd #{current_release} && bundle exec thin restart -s 2 -d -a 127.0.0.1 -e #{rails_env} -O"
  end

  task :stop do
    run "cd #{current_release} && bundle exec thin stop -s 2"
  end
end

