namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export do
    on roles(:app) do
      within current_path do
        execute "sudo bundle exec foreman export upstart /etc/init -a #{fetch(:application)} -u #{fetch(:user)} -l #{fetch(:shared_path)}/log"
      end
    end

  end

  desc "Start the application services"
  task :start, :roles => :app do
    sudo "start #{fetch(:application)}"
  end

  desc "Stop the application services"
  task :stop, :roles => :app do
    sudo "stop #{fetch(:application)}"
  end

  desc "Restart the application services"
  task :restart, :roles => :app do
    run "sudo start #{fetch(:application)} || sudo restart #{fetch(:application)}"
  end
end
