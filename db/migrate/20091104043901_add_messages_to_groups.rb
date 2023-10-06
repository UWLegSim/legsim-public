class AddMessagesToGroups < ActiveRecord::Migration[4.2]
  def self.up
    add_column :groups, :private_announcement, :text
    add_column :groups, :public_announcement, :text
  end

  def self.down
    remove_column :groups, :private_announcement
    remove_column :groups, :public_announcement
  end
end
