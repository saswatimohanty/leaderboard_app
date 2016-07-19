class User < ActiveRecord::Base
	validates :name, presence: true
	validates :username, presence: true, uniqueness: true

	require 'net/http'

  def github_user?
    uri = URI("https://github.com/#{self.username}/")
    response = Net::HTTP.get_response(uri)
    response.code == '404' ? false : true
  end

  def update_github_information
  	self.total_commits = get_total_commits
  	self.save
  end

  def get_total_commits
  	commits_service = GithubCommitService.new(self)
  	total_commits = commits_service.find_user_total_commits_in_last_year(self)
  end
end