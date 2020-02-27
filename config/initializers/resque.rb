Resque.redis = ENV['CACHE_RESQUE_PATH']
Resque.redis.namespace = "resque:pokerking:api"
Resque.logger = Logger.new(Rails.root.join('log', "#{Rails.env}_resque.log"))
Resque.logger.level = Logger::DEBUG
puts 'after resque initialized'