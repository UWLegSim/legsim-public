class AddDefaultTalliesToVotes < ActiveRecord::Migration[4.2]
  def self.up
    change_column :votes, :yes_cache, :integer, :default => 0
    change_column :votes, :no_cache, :integer, :default => 0
    change_column :votes, :present_cache, :integer, :default => 0
  end

  def self.down
    change_column :votes, :yes_cache, :integer, :default => nil
    change_column :votes, :no_cache, :integer, :default => nil
    change_column :votes, :present_cache, :integer, :default => nil
  end
end
