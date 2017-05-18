require 'yaml'
require 'yaml/dbm'

env_file = File.join('config', 'my_env.yml')

YAML.load_file(env_file).each do |key, value|
  ENV[key.to_s] = value
end if File.exists?(env_file)

text_file = File.join('config', 'cat_messages.yml')

CAT_TEXTS = YAML.load_file(text_file)["text_for_images"] if File.exists?(text_file)

# init db

DB_PATH = "db/store"

DB = YAML::DBM.open(DB_PATH, 0666, DBM::WRCREAT)
