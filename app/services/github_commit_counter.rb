class GithubCommitCounter
	attr_reader :connection

	def initialize(user)
		@client = Hurley::Client.new("https://api.github.com")
		@connection = @client.connection
		@connection = Hurley::HttpCache.new
		@stats = GithubStats.new(user.username)
		@user = user
	end

	def find_user_total_commits_in_last_year(user)
    @stats.data.scores.reduce(:+)
  end

  def find_todays_commits(user)
  	@stats.data.today
  end
end