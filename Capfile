# totally "borrowed" from http://gist.github.com/109156

ssh_options[:keys] = %w(~/.ssh/id_rsa ~/.ssh/id_dsa)
ssh_options[:forward_agent] = true
 
set :user, "joho"
set :use_sudo, false
 
role :appserver, "whoisjohnbarton.com"
 
desc "Redeploy the app"
task :deploy do
  run "/opt/apps/whoisjohnbarton/blog; git pull; rake restart_app"
end