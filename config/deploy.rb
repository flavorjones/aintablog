namespace :cache do
  desc "Remove cache directory, essentially expiring the whole thing"
  task :expire do
    run "rm -rf #{current_path}/public/cache"
  end
end

set :keep_releases, 5
set :application, "aintablog"
# need to add entry to .ssh/config to set remote username to dalessio
set :repository, "ssh://dalessio.csa.net/var/cache/git/daless.io/#{application}"
set :scm, :git
set :branch, "deploy"
set :user, "mike"
set :password, "the sounds of science"
set :runner, "mike"
set :deploy_to, "/home/mike/#{application}"
set :deploy_via, :remote_cache
set :repository_cache, "cache/#{application}"

set :config_files, %w{database.yml settings.yml mongrel_cluster.yml}
set :mongrel_conf, "/etc/mongrel_cluster/#{application}.yml"

ssh_options[:paranoid] = false
ssh_options[:forward_agent] = true

task :production do
  role :web, "slice1.daless.io"
  role :app, "slice1.daless.io"
  role :db, "slice1.daless.io", :primary => true
  set :rails_env, "production"
end
