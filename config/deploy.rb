set :application, "devops-metrix"
set :repo_url,    "git@github.com:jrbeaudouin/devops-metrix.git"

set :stages, [:staging, :production]
set :default_stage, :staging
set :ssh_options, { :forward_agent => true }

set :format, :pretty
set :keep_releases, 3

set :pty, true

namespace :deploy do
  desc "Install dependencies and build app"
  task :updated do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd #{release_path} && npm install --quiet"
    end
  end
end
