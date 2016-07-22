class GithubInformationWorker
	include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
  	users = User.all
    users.each do |user|
    	$leaderboard.rank_member(user.username, user.total_commits)
   	 	$leaderboard.rank_for(user.username)
      TotalCommitsWorker.perform_async(user.id)
      TotalReposWorker.perform_async(user.id)
    end
  end
end