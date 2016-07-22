class TotalReposWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform(user_id)
		user = User.find_by(id: user_id)
		repos_service = GithubPublicRepoService.new(user)
  	public_repos = repos_service.find_user_public_repos(user)
  	user.public_repos = public_repos.count
  	user.save
	end
end