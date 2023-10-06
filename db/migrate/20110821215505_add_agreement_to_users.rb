class AddAgreementToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :agreement, :boolean, :default => false
  end

  def self.down
    remove_column :users, :agreement
  end
end
