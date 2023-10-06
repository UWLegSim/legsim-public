class CreateGroupMemberships < ActiveRecord::Migration[4.2]
  def self.up
    create_table :group_memberships do |t|
      t.integer :group_id
      t.integer :chamber_role_id
      t.timestamps
    end
  end

  def self.down
    drop_table :group_memberships
  end
end
