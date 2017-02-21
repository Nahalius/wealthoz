require "bundler/capistrano"
require "rvm/capistrano"

server "128.199.50.114", :web, :app, :db, primary: true

set :application, "wealthoz"
set :user, "deployer"
set :port, 22
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false
set :rvm_type, :system

set :scm, "git"
set :repository, 'git@bitbucket.org:WealthOZ/wealthoz-2.01.git'
set :rvm_ruby_version, 'ruby-2.1.4'
set :branch, "master"


default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    # sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/nginx.conf"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"

  namespace :db do
    task :reset do
      run "cd #{current_path} && bundle exec rake db:reset RAILS_ENV=#{rails_env}"
    end

    task :sample do
      run "cd #{current_path} && bundle exec rake db:sample RAILS_ENV=#{rails_env}"
    end

    desc "Drop the database !!!"
    task :drop do
      run "cd #{current_path} && bundle exec rake db:drop RAILS_ENV=#{rails_env}"
    end

    desc "Seed the database"
    task :seed do
      run "cd #{current_path} && bundle exec rake db:seed RAILS_ENV=#{rails_env}"
    end

    desc "Create the database"
    task :create do
      run "cd #{current_path} && bundle exec rake db:create RAILS_ENV=#{rails_env}"
    end
  end
end
