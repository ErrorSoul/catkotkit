require 'rubygems'
require 'bundler/setup'
require 'twitter'
require 'colorize'
require 'rest-client'
require 'open-uri'
require './boot'
require './textio'

REG = /src\s*=\s*"([^"]*)"/

PARAMS = {
  format: "html",
  results_per_page: 1,
  type: 'png,jpg',
  size: 'med'
}

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["CONSUMER_KEY"]
  config.consumer_secret     = ENV["CONSUMER_SECRET"]
  config.access_token        = ENV["OAUTH_TOKEN"]
  config.access_token_secret = ENV["OAUTH_TOKEN_SECRET"]
end


response = RestClient.get(ENV["CAT_API_URL"], params: PARAMS)

if result = REG.match(response.body)
  image_url = result[1]

  open('image.png', 'wb') do |file|
    file << open(image_url).read
  end
end

#client.update_with_media("Source url: #{image_url}", open(image_url))
