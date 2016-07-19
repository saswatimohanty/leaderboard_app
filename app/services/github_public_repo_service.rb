class GithubPublicRepoService
	def initialize(user)
		@github = Github.new
	end

	def find_user_public_repos(user)
  	@repos = @github.repos.list user: "#{user.username}"
	end
end