require "capistrano/ext/multistage"

# Name the application
set :application, "ashlee"
#
# Where we are deploying to
set :location, "ec2-23-20-227-105.compute-1.amazonaws.com"

# Multistage deployment. Each one of these corresponds to a <env_name>.rb file in config/deploy/ which contains specific options for each stage
set :stages, ["production"]
set :default_stage, "production"

# Setup connection options. Set up your ec2 permissions via ssh-add and this option will allow you to connect
set :ssh_options, { :forward_agent => true }
default_run_options[:pty] = true

# The user and permissions used while performing cap tasks on the server
set :user, 'ec2-user'
set :use_sudo, false

# Set access to git repo...
# On default deployment, Capistrano executes git clone|checkout commands on
# prod server (deploying to).
# However, its a security concern to setup our prod server to access git repo (a private key
# needs to be put on the prod server for passwordless access).
# So instead we only allow dev machine to access git repo via ssh key.
# So during Capistrano deployment, latest code is checked out from repo to dev/local box,
# compressed, sent via scp to the prod server and then uncompressed.
# Takes tad longer to deploy an update but increased security makes up for the slight delay.
# Setting up Capistrano to use this deployment strategy is as simple as adding deploy_via :copy or :remote_cache
set :deploy_via, :copy
# Deploy from local to eliminate remote server needing git ssh key
set :repository,  'git@github.com:DaRizat/ashlee.git'                  
set :scm, :git

# Set up the different roles. These can be different locations for more complex deployments, or the same for simple deployment.
role :web, location
role :app, location
role :db, location, :primary => true

# Enable Capistrano use with rvm.
require 'rvm/capistrano'

# Specify gemset you want to use on server.
set :rvm_ruby_string, '1.9.3@rails_server' 
set :rvm_type, :user

# Enable Capistrano use with Bundler
require 'bundler/capistrano'

# Run a bundle update on the remote (should not be necessary)
namespace :bundle do
  task :update do
    run "cd #{current_path} && bundle update"
  end
end

# Some custom deployment tasks
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  task :initial do 
    system "cap deploy"
    system "cap deploy:db:create"
    system "cap deploy:db:migrate"
  end

  namespace :db do
    desc "Create Production Database"
    task :create do
      puts "\n\n=== Creating the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:create RAILS_ENV=production"
    end
  
    desc "Migrate Production Database"
    task :migrate do
      puts "\n\n=== Migrating the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:migrate RAILS_ENV=production"
    end
  end
end
