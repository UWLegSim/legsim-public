class AddEditedToContents < ActiveRecord::Migration[4.2]
  def self.up
    add_column :contents, :altered, :boolean, :default => false
  end

  def self.down
    remove_column :contents, :altered
  end
end
