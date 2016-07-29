$redis = Redis.new(ENV['REDISCLOUD_URL']] || 'redis://127.0.0.1:6379')

redis_options = {redis_connection: $redis}
$leaderboard = Leaderboard.new('highcommits', 
																Leaderboard::DEFAULT_OPTIONS.merge(score_key: :total_commits), 
																redis_options
															)