class GithubWorker
  include Sidekiq::Worker
  include LeaderboardMethod
  sidekiq_options retry: false

  def perform
    users = User.all
    users.each do |user|
      TotalCommitsWorker.perform_async(user.id)
      leaderboard.rank_member(user.username, user.total_commits)
      user.rank = leaderboard.rank_for(user.username)
      user.save
    end
  end
end

Sidekiq::Cron::Job.create(name: 'Github worker - every day', cron: '0 18 * * *', class: 'GithubWorker')