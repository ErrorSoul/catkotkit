namespace :logs do
  desc "tail rails logs"
  task :bot_logs do
    on roles(:app) do
      execute s"tail -f #{shared_path}/log/logfile.log"
    end
  end

  desc "tail service logs"
  task :s_logs do
    on roles(:app) do
      execute :sudo, "tail -f /var/log/upstart/catkotkit-web-1.log"
    end
  end

end
