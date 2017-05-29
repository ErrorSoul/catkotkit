class DB_Store
  attr_reader :db

  def initialize
    @db = DB
    set_time_flags
  end

  def old_tweets
    DB['old_tweets'] || []
  end

  def last_reply_id
    DB['last_reply_id'] || 10000 # random integer
  end

  def set(attr, value)
    DB[attr.to_s] = value
  end

  def update_old_tweets(old_tweets)
    set(:old_tweets, old_tweets)
    LOGGER.info "Write new tweets to db".green
  end

  def update_last_reply(last_reply_id)
    set(:last_reply_id, last_reply_id)
    LOGGER.info "Write last reply #{last_reply_id} to db".green
  end

  def hour_tweet_time
    DB['hour_tweet_time']
  end

  def update_hour_tweet_time
    time = Time.now + 3600
    set(:hour_tweet_time, Time.now + 7200) # 60 s * 60 (1 hour)
    LOGGER.info "Update hour tweet time to #{time}".rjust(60, '.').yellow
  end

  def reply_time
    DB['reply_time']
  end

  def update_reply_time
    time = Time.now + 25
    set(:reply_time, time) # 25 sec
    LOGGER.info "Update reply time to #{time}".rjust(60, '.').yellow
  end

  private

  def set_time_flags
    update_hour_tweet_time
    update_reply_time
  end
end
