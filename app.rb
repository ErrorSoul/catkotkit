# coding: utf-8
require 'rubygems'
require 'bundler/setup'
require 'twitter'
require 'colorize'
require 'open-uri'
require 'logger'
require './boot'
require './textio'
require './lib/db_store'
require './lib/cat_image_api'
require './lib/twi/client.rb'

LOGGER = Logger.new('log/logfile.log')

system( 'touch dfadsfdsafadsfadsfadsf.txt')
$stdout.sync = true
REG = /\b[Cc]\s*[Aa]\s*[Tt]\b/ # From A. Pustobaev
# REG = /\bc\s*a\s*t\b/
db_store = DB_Store.new
client   = Twi::Client.new

def post_cat_image_every_hour(client, db_store)
  if image_url = CatImageAPI.get_image
    old_tweets = db_store.old_tweets
    LOGGER.info "OLD tweets is #{old_tweets.inspect}"

    tweet_text, new_tweets  = client.send_hour_tweet(image_url, old_tweets, false)

    db_store.update_old_tweets(new_tweets)
    LOGGER.info tweet_text
  end
end


def replying(client, db_store)
  last_reply_id = db_store.last_reply_id
  mentions = client.mentions_timeline(since_id: last_reply_id)

  unless mentions.empty?
    mentions.select { |tweet| tweet.full_text =~ REG }.map do |tweet|
      if image_url = CatImageAPI.get_image
        LOGGER.info image_url
        #client.reply(tweet, image_url)
      end
    end

    last_reply_id = mentions.last.id
    db_store.update_last_reply(last_reply_id)
  end
end




loop do

  time = Time.now
  LOGGER.info "Time now is #{time}".blue
  hour_tweet_time  = db_store.hour_tweet_time
  reply_tweet_time = db_store.reply_time

  LOGGER.info "HOUR TWEET TIME is #{hour_tweet_time}".red
  LOGGER.info "REPLY TIME is #{reply_tweet_time}".red

  if time >=  hour_tweet_time
    Thread.new do
      post_cat_image_every_hour(client, db_store)
      db_store.update_hour_tweet_time
    end
  end

  if time >=  reply_tweet_time
    Thread.new do
      replying(client, db_store)
      db_store.update_reply_time
    end
  end



  #replying(client, db_store)
  #post_cat_image_every_hour(client, db_store)
end
