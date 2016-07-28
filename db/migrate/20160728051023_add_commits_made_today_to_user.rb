class AddCommitsMadeTodayToUser < ActiveRecord::Migration
  def change
    add_column :users, :commits_made_today, :integer
  end
end
