require "bundler/capistrano"
require "delayed/recipes"

set :application, "178.79.189.97"
set :repository, "git://github.com/gauravtiwari5050/gyan_school.git"

set :scm, "git"
set :branch, "master"

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :app, application
role :web, application
role :db,  application, :primary => true

set :user, "cchq"
set :use_sudo, false
set :deploy_to, "/home/cchq/cloudclass"
ssh_options[:auth_methods] = "publickey"
# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
   task :copy_database_configuration do
     production_db_config = "/home/cchq/production.gyan.database.yml"
     production_mail_config = "/home/cchq/production.gyan.setup_mail.rb"
     production_carrierwave_config = "/home/cchq/production.gyan.carrierwave.rb"
     production_config = "/home/cchq/production_school.rb"
     run "cp #{production_db_config} #{release_path}/config/database.yml"
     run "cp #{production_mail_config} #{release_path}/config/initializers/setup_mail.rb"
     run "cp #{production_carrierwave_config} #{release_path}/config/initializers/carrierwave.rb"
     run "cp #{production_config} #{release_path}/config/environments/production.rb"
   end

   after "deploy:update_code" , "deploy:copy_database_configuration" 
 end
before "deploy:restart", "delayed_job:stop"
after  "deploy:restart", "delayed_job:start"
after "deploy:stop",  "delayed_job:stop"
after "deploy:start", "delayed_job:start"

after 'deploy:update_code' do
  run "cd #{release_path}; RAILS_ENV=production rake assets:precompile"
end
