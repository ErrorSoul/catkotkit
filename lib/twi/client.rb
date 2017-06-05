module Twi
  class Client

    #HASHTAGS = ['#котовести', '#котоновости'].join(' ')
    HASHTAGS  = ['#catnews', '#catstories', '#cat'].join(' ')

    attr_reader :client

    def initialize
      set_params
    end

    def send_hour_tweet(image_url, old_tweets, debug=false)
      tweet_text, new_tweets = prepare_text_tweet(old_tweets)
      LOGGER.info "TEXT SAMPLE IS #{tweet_text}".blue
      @client.update_with_media(tweet_text, open(image_url)) unless debug
      [tweet_text, new_tweets]
    end

     def mentions_timeline(*args)
      @client.mentions_timeline(*args)
    end

     def reply(tweet, image_url)
       @client.update_with_media(
          "@#{tweet.user.screen_name}",
          open(image_url),
          in_reply_to_status_id: tweet.id
        )
     end

    private

    def set_params
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["CONSUMER_KEY"]
        config.consumer_secret     = ENV["CONSUMER_SECRET"]
        config.access_token        = ENV["OAUTH_TOKEN"]
        config.access_token_secret = ENV["OAUTH_TOKEN_SECRET"]
      end
    end

    def prepare_text_tweet(old_tweets)
      # return tweet text and updated tweets to store in db
      text_sample = CAT_TEXTS.sample

      new_tweets =
        if old_tweets.size < 33
          while old_tweets.include?(text_sample)
            text_sample = CAT_TEXTS.sample
          end
          old_tweets + [text_sample]
        else
          [text_sample]
        end

      tweet_text = correct_tweet_length(text_sample)

      [tweet_text, new_tweets]
    end
  end

  def correct_tweet_length(text_sample)
    if (140 - text_sample.size) < HASHTAGS.size
      text_sample
    else
      "#{text_sample} #{HASHTAGS}"
    end
  end

end
