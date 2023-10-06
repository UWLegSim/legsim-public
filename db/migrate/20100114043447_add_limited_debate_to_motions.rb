class AddLimitedDebateToMotions < ActiveRecord::Migration[4.2]
  def self.up
    add_column :motions, :limited_debate, :boolean, :default => false
  end

  def self.down
    remove_column :motions, :limited_debate
  end
end
