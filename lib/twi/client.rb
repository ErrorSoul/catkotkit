class Twi::Client

  def initialize
    set_params
  end


  def send_photo(image_url)


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

  def get_text_tweet(old_tweets)
    text_sample = CAT_TEXTS.sample

    if old_tweets.size < 12
      while old_tweets.include?(text_sample)
        text_sample = CAT_TEXTS.sample
      end
      old_tweets + [text_sample]
    else
      [text_sample]
    end
  end


end
