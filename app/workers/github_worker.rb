class GithubWorker
	include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
  	users = User.all
    users.each do |user|
      TotalCommitsWorker.perform_async(user.id)
      GithubInformationWorker.perform_async(user.id)
    end
  end
end