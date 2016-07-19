class AddPublicReposToUsers < ActiveRecord::Migration
  def change
    add_column :users, :public_repos, :integer
  end
end
