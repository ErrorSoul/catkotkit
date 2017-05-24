namespace :foreman do
  # desc "Export the Procfile to Ubuntu's upstart scripts"
  # task :export do
  #   on roles(:app) do
  #     within current_path do
  #       execute :rbenv, :exec,:bundle,   "foreman export upstart /etc/init --procfile=./Procfile -a #{fetch(:application)} -u #{fetch(:deploy_user)} -l #{current_path}/log"
  #     end
  #   end

  # end

  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export do
    on roles(:app) do
      within current_path do
        puts Dir.pwd
        puts current_path
        puts shared_path
        puts "#{fetch(:deploy_user)}"
        #execute "echo PATH=\"$PATH\"\n > #{current_path}/.env"
        #execute "cd #{current_path} && rbenv sudo bundle exec foreman export upstart /etc/init -a catkotkit -u #{fetch(:deploy_user)} -l #{shared_path}/log -d #{current_path}"
        #execute :sudo, :rbenv,  "bundle exec foreman export upstart /etc/init -a catkotkit -u #{fetch(:deploy_user)} -l #{shared_path}/log -d #{current_path}"

        execute :rbenv, :sudo,  "foreman export upstart /etc/init -a #{fetch(:application)} -u #{fetch(:deploy_user)} -l #{shared_path}/log"
      end
    end
  end


[:start, :stop, :restart, :status].each do |action|
  desc "#{action} the foreman processes"
  task action do
    on roles(:app) do
      execute "sudo service catkotkit #{action}"
    end
  end
end
end
