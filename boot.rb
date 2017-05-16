require 'yaml'

env_file = File.join('config', 'my_env.yml')

YAML.load_file(env_file).each do |key, value|
  ENV[key.to_s] = value
end if File.exists?(env_file)
