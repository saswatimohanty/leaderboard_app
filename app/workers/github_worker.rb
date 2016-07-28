class GithubWorker
	include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
  	users = User.all
    users.each do |user|
    	$leaderboard.rank_member(user.username, user.total_commits)
   	 	$leaderboard.rank_for(user.username)
      TotalCommitsWorker.perform_async(user.id)
    end
  end
end

Sidekiq::Cron::Job.create(name: 'Github worker - every 1min', cron: '*/1 * * * *', class: 'GithubWorker')