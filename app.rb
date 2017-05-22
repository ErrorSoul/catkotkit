# coding: utf-8
require 'rubygems'
require 'bundler/setup'
require 'twitter'
require 'colorize'
require 'open-uri'
require './boot'
require './textio'
require './lib/db_store'
require './lib/cat_image_api'

HASHTAGS = ['#котовести', '#котоновости'].join(' ')

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["CONSUMER_KEY"]
  config.consumer_secret     = ENV["CONSUMER_SECRET"]
  config.access_token        = ENV["OAUTH_TOKEN"]
  config.access_token_secret = ENV["OAUTH_TOKEN_SECRET"]
end

db_store = DB_Store.new

def post_cat_image_every_hour(client, db_store)
  if image_url = CatImageAPI.get_image
    old_tweets = db_store.old_tweets
    puts "OLD tweets is #{old_tweets.inspect}"
    text_sample = CAT_TEXTS.sample

    new_tweets =
      if old_tweets.size < 12
        while old_tweets.include?(text_sample)
          text_sample = CAT_TEXTS.sample
        end
        old_tweets + [text_sample]
      else
        [text_sample]
      end

    puts "TEXT SAMPLE IS #{text_sample}".blue
    db_store.set_old_tweets(new_tweets)
    puts " Write tweet to db ".green


    tweet_text = "#{text_sample} #{HASHTAGS}"
    puts tweet_text
    client.update_with_media(tweet_text, open(image_url))
  end

end


post_cat_image_every_hour(client, db_store)

p client.mentions_timeline
