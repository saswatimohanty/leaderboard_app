class GithubInformationRetriever
	def initialize(user)
		@github = Github.new
	end

	def find_user_public_repos(user)
  	@repos = @github.repos.list user: "#{user.username}"
	end

	def find_followers(user)
		@followers = @github.users.followers.list "#{user.username}"
	end
end