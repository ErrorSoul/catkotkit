require 'rubygems'
require 'bundler/setup'
require 'twitter'
require 'colorize'
require 'rest-client'
require 'open-uri'




CAT_API_URL        = 'http://thecatapi.com/api/images/get'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = CONSUMER_KEY
  config.consumer_secret     = CONSUMER_SECRET
  config.access_token        = OAUTH_TOKEN
  config.access_token_secret = OAUTH_TOKEN_SECRET
end

REG = /src\s*=\s*"([^"]*)"/

PARAMS = {
  format: "html",
  results_per_page: 1,
  type: 'png,jpg',
  size: 'med'

}
response = RestClient.get(CAT_API_URL, params: PARAMS)

puts response
puts response.body

if result = REG.match(response.body)
  image_url = result[1]
  puts image_url
  open('image.png', 'wb') do |file|
    file << open(image_url).read
  end
end

client.update_with_media("Source url: #{image_url}", open(image_url))
