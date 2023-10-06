class AddPriorityToReferrals < ActiveRecord::Migration[4.2]
  def self.up
    add_column :referrals, :priority, :string
  end

  def self.down
    drop_column :referrals, :priority
  end
end
