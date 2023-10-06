class ChangeTimeOnVotes < ActiveRecord::Migration[4.2]
  def self.up
    rename_column :votes, :start, :start_at
    rename_column :votes, :finish, :finish_at
  end

  def self.down
    rename_column :votes, :start_at, :start
    rename_column :votes, :finish_at, :finish
  end
end
