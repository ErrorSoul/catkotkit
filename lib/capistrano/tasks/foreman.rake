namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export do
    on roles(:app) do
      within current_path do
        execute :rbenv, :exec,:bundle, :exec,  "foreman export upstart /etc/init --procfile=./Procfile -a #{fetch(:application)} -u #{fetch(:deploy_user)} -l #{current_path}/log"
      end
    end

  end


desc "Start the application services"
  task :start do
    on roles(:app) do
      within current_path do
        execute :sudo, :start, :catkotkit
      end
    end
  end

  desc "Stop the application services"
  task :stop do
    on roles(:app) do
      within current_path do
        execute :bundle, :exec, :foreman, :stop, "catkotkit"
      end
    end
  end

  desc "Restart the application services"
  task :restart do

      on roles(:app) do
        within current_path do
          sudo "bundle exec foreman start || sudo bundle exec foreman restart"
        end
    end
  end
end
