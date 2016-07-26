class GithubInformationWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform(user_id)
		user = User.find_by(id: user_id)
		repos_service = GithubInformationRetriever.new(user)
  	public_repos = repos_service.find_user_public_repos(user)
  	user.public_repos = public_repos.count
  	followers = repos_service.find_followers(user) 
  	user.followers = followers.count
  	user.save
	end
end