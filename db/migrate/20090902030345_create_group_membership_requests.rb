class CreateGroupMembershipRequests < ActiveRecord::Migration[4.2]
  def self.up
    create_table :group_membership_requests do |t|
      t.integer :group_id
      t.integer :chamber_role_id
      t.integer :rank
      t.timestamps
    end
  end

  def self.down
    drop_table :group_membership_requests
  end
end
