# config valid only for current version of Capistrano
lock "3.8.1"

set :application, "catkotkit"
set :repo_url, "git@github.com:ErrorSoul/catkotkit.git"

set :deploy_to, "/home/deployer/apps/#{fetch(:application)}"
set :deploy_user, 'deployer'

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.4.1'
set :rbenv_path, "/usr/local/rbenv"
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w(rake gem bundle ruby rails)
set :rbenv_roles, :all # default value
# Default value for :scm is :git

# Default value for :format is :pretty
#set :format, :airbrush

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true


# Default value for linked_dirs is []
set :linkded_files, ["config/my_env.yml"]
set :linked_dirs, %w{bin log tmp/pids db}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5
