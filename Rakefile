desc 'start the app up'
task :start_app do
  `thin -s 2 -C config.yml -R blog.ru start`
end

desc 'stop the app'
task :stop_app do
  `thin -s 2 -C config.yml -R blog.ru stop`
end

task :restart_app => [:stop_app, :start_app]