set :stage, :prod
set :branch, "master"

role :app, %w{ubuntu@62.4.19.90}
set :deploy_to,   "/var/www/devops-metrix"
