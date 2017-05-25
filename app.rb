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

class MultiIO
  def initialize(*targets)
     @targets = targets
  end

  def write(*args)
    @targets.each {|t| t.write(*args)}
  end

  def close
    @targets.each(&:close)
  end
end

log_file = File.open("log/debug.log", "a")
LOGGER = Logger.new MultiIO.new(STDOUT, log_file)
#LOGGER = Logger.new('log/logfile.log')

system( 'touch dfadsfdsafadsfadsfadsf.txt')
puts 'dsfasdfadsfaf'
$stdout.sync = true
REG = /\b[Cc]\s*[Aa]\s*[Tt]\b/ # From A. Pustobaev
# REG = /\bc\s*a\s*t\b/  \i
db_store = DB_Store.new
client   = Twi::Client.new

def post_cat_image_every_hour(client, db_store)
  LOGGER.info "hour image start"
  if image_url = CatImageAPI.get_image
    old_tweets = db_store.old_tweets
    LOGGER.info "OLD tweets is #{old_tweets.inspect}"

    tweet_text, new_tweets  = client.send_hour_tweet(image_url, old_tweets)

    db_store.update_old_tweets(new_tweets)
    LOGGER.info tweet_text
  end
end


def replying(client, db_store)
  LOGGER.info "REPLYING START"
  last_reply_id = db_store.last_reply_id
  mentions = client.mentions_timeline(since_id: last_reply_id)
  LOGGER.info mentions.inspect

  unless mentions.empty?
    LOGGER.info 'mentions exist'
    mentions.select { |tweet| tweet.full_text =~ REG }.map do |tweet|
      if image_url = CatImageAPI.get_image
        LOGGER.info image_url
        sleep(2)
        client.reply(tweet, image_url)
      end
    end

    last_reply_id = mentions.last.id
    db_store.update_last_reply(last_reply_id)
  end
end

loop do
  sleep rand(5..10)
  time = Time.now
  LOGGER.info "Time now is #{time}".blue
  hour_tweet_time  = db_store.hour_tweet_time
  reply_tweet_time = db_store.reply_time

  LOGGER.info "HOUR TWEET TIME is #{hour_tweet_time}".red
  LOGGER.info "REPLY TIME is #{reply_tweet_time}".red

  if time >= hour_tweet_time
    puts 'check hour'
    post_cat_image_every_hour(client, db_store)
    db_store.update_hour_tweet_time
  end

  if time >= reply_tweet_time
    puts 'check reply'
    replying(client, db_store)
    db_store.update_reply_time
  end
end

def most_retweeted_in_homeline(db_store)
    last_homeline_tweet = db_store.last_periodic_tweet
    periodic_tweets = client.take_periodic_tweets(since_id: last_homeline_tweet.id)
    most_rt_tweets = search_most_rt(periodic_tweets)
    db_store.update_most_retweeted_home(most_rt_tweets)
end
