class User < ActiveRecord::Base
	validates :name, presence: true
	validates :username, presence: true, uniqueness: true

	require 'net/http'

  def github_user?
    uri = URI("https://github.com/#{self.username}/")
    response = Net::HTTP.get_response(uri)
    response.code == '404' ? false : true
  end

  def get_rank
  	leaderboard_hash = $leaderboard.around_me(self.username)
  	all_ranks = leaderboard_hash.map { |r| r[:rank] }
  end
end