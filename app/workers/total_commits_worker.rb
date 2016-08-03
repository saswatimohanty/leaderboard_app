class TotalCommitsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id)
    user = User.find_by(id: user_id)
    commits_service = GithubCommitCounter.new(user)
    total_commits = commits_service.find_user_total_commits_in_last_year(user)
    user.total_commits = total_commits
    commits_made_today = commits_service.find_todays_commits(user)
    user.commits_made_today = commits_made_today
    user.save
  end
end