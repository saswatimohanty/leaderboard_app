class GithubInformationRetriever
	def initialize(user)
		@github = Github.new
	end

	def find_user_public_repos(user)
  	@github.repos.list user: "#{user.username}"
	end

	def find_followers(user)
		@github.users.followers.list "#{user.username}"
	end
end