module LeaderboardMethod
  def leaderboard
    redis_options = {redis_connection: $redis}
    lb ||= Leaderboard.new('highcommits', 
                            Leaderboard::DEFAULT_OPTIONS.merge(score_key: :total_commits), 
                            redis_options
                          )
  end
end