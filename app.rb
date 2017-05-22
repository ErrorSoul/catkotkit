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
require './lib/twi/client.rb'



db_store = DB_Store.new
client   = Twi::Client.new

def post_cat_image_every_hour(client, db_store)
  if image_url = CatImageAPI.get_image
    old_tweets = db_store.old_tweets
    puts "OLD tweets is #{old_tweets.inspect}"

    tweet_text, new_tweets  = client.send_hour_tweet(image_url, old_tweets)

    db_store.update_old_tweets(new_tweets)
    puts tweet_text
  end

end

post_cat_image_every_hour(client, db_store)
