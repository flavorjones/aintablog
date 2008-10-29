namespace :cache do
  desc "Remove cache directory, essentially expiring the whole thing"
  task :expire do
    run "rm -rf #{current_path}/public/cache"
  end
end

set :keep_releases, 5
set :application, "aintablog"
set :repository, "ssh://dalessio.csa.net/var/cache/git/daless.io/aintablog"
set :scm, :git
set :git_shallow_clone, 1
set :user, "mike"
set :password, "the sounds of science"
set :runner, "mike"
set :deploy_to, "/home/mike/#{application}"
set :deploy_via, :remote_cache
set :repository_cache, "/home/mike/cache/#{application}"

ssh_options[:paranoid] = false

task :production do
  role :web, "slice1.daless.io"
  role :app, "slice1.daless.io", :mongrel => true
  role :db, "slice1.daless.io", :primary => true
  set :rails_env, "production"
end
