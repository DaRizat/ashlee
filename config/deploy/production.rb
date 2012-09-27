load "deploy/assets"

before "deploy:restart", "deploy:assets:precompile"

set :deploy_to, "/home/ec2-user/www/ashlee"
