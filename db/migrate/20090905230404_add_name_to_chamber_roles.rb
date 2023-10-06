class AddNameToChamberRoles < ActiveRecord::Migration[4.2]
  def self.up
    add_column :chamber_roles, :first_name, :string
    add_column :chamber_roles, :last_name, :string
  end

  def self.down
    remove_column :chamber_roles, :first_name
    remove_column :chamber_roles, :last_name
  end
end
