$redis = Redis.new(:driver => :hiredis)

redis_options = {redis_connection: $redis}
$leaderboard ||= Leaderboard.new('highcommits', 
																Leaderboard::DEFAULT_OPTIONS.merge(score_key: :total_commits), 
																redis_options
															)