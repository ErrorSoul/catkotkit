namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export do
    on roles(:app) do
      within current_path do
        execute :rbenv, :exec, "bundle exec foreman export upstart /etc/init --procfile=./Procfile -a #{fetch(:application)} -u #{fetch(:user)} -l #{shared_path}/log"
      end
    end

  end

  desc "Start the application services"
  task :start do
    on roles(:app) do
      within current_path do
        execute :rbenv, :exec, "foreman start #{fetch(:application)}"
      end
    end

  end

  desc "Stop the application services"
  task :stop do
    on roles(:app) do
      within current_path do
        execute :rbenv, :exec, "foreman stop #{fetch(:application)}"
      end
    end
  end

  desc "Restart the application services"
  task :restart do
    on roles(:app) do
      within current_path do
        execute :rbenv, :exec, "foreman start #{fetch(:application)} || foreman restart #{fetch(:application)}"
      end
    end
  end
end
