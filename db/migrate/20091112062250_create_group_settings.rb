class CreateGroupSettings < ActiveRecord::Migration[4.2]
  def self.up
    create_table :group_settings do |t|
      t.integer :group_id
      t.string  :name
      t.string  :value
      t.timestamps
    end
  end

  def self.down
    drop_table :group_settings
  end
end
