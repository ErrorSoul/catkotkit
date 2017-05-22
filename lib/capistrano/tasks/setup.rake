namespace :setup do

  desc "Upload env.yml file."
  task :upload_yml do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      upload! StringIO.new(File.read("config/my_env.yml")), "#{shared_path}/config/my_env.yml"
    end
  end



  desc "test tweet"
  task :test_tweet do
     on roles(:app) do
       puts "#{current_path}"
       within "#{current_path}" do
         puts system('pwd')
         execute "ruby #{current_path}/app.rb"
       end
     end
   end

  # desc "Symlinks config files for Nginx and Unicorn."
  # task :symlink_config do
  #   on roles(:app) do
  #     execute "rm -f /etc/nginx/sites-enabled/default"

  #     execute "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{fetch(:application)}"
  #     execute "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{fetch(:application)}"
  #  end
  # end

end
