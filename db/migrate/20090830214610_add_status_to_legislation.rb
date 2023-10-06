class AddStatusToLegislation < ActiveRecord::Migration[4.2]
  def self.up
    add_column :legislation, :status, :string
  end

  def self.down
    remove_column :legislation, :status
  end
end
