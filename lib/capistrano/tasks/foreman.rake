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

  # https://github.com/capistrano/sshkit/blob/master/EXAMPLES.md
  # https://www.extendi.it/blog/2015/8/18/49-foreman-and-upstart
  # http://anlek.com/2015/01/using-foreman-with-upstart-capistrano/
  task :export do
    on roles(:app) do
      within current_path do
          with path: '/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH' do
            pt = capture(:echo, 'PATH=\"$PATH\"')

            File.open('.env', 'wb') do |f| f.write pt end
            upload!(StringIO.new(File.read(".env")), "#{current_path}/.env")
            execute :rbenv, :sudo,  "bundle exec foreman export upstart /etc/init -a catkotkit -u #{fetch(:deploy_user)} -l #{shared_path}/log"
          end
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

# helper PATH that work
# PATH="/usr/local/rbenv/shims:/usr/local/rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
