namespace :logs do
  desc "tail rails logs"
  task :bot_logs do
    on roles(:app) do
      execute "tail -f #{shared_path}/log/logfile.log"
    end
  end

end
