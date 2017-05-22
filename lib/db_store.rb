class DB_Store
  attr_reader :db

  def initialize
    @db = DB
  end

  def old_tweets
    DB['old_tweets'] || []
  end

  def set(attr, value)
    DB[attr.to_s] = value
  end

  def set_old_tweets(old_tweets)
    DB['old_tweets'] = old_tweets
  end
end
