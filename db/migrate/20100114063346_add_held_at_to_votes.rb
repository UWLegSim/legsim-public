class AddHeldAtToVotes < ActiveRecord::Migration[4.2]
  def self.up
    add_column :votes, :held_at, :datetime
  end

  def self.down
    remove_column :votes, :held_at
  end
end
