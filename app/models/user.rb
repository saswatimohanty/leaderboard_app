class User < ActiveRecord::Base
  validates :name, presence: true
  validates :username, presence: true, uniqueness: true

  def github_user?
    uri = URI("https://github.com/#{self.username}/")
    response = Net::HTTP.get_response(uri)
    response.code == '404' ? false : true
  end
end