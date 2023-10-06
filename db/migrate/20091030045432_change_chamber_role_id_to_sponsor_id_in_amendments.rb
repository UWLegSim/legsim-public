class ChangeChamberRoleIdToSponsorIdInAmendments < ActiveRecord::Migration[4.2]
  def self.up
    add_column :amendments, :sponsor_id, :integer
    add_column :amendments, :number, :integer
    remove_column :amendments, :chamber_role_id
  end

  def self.down
    remove_column :amendments, :sponsor_id
    remove_column :amendments, :number
    add_column :amendments, :chamber_role_id, :integer
  end
end
