class CreateGroupLeaders < ActiveRecord::Migration[4.2]
  def self.up
    create_table :group_leaders do |t|
      t.integer :chamber_role_id
      t.integer :group_id
      t.string  :title
      t.boolean :primary
      t.timestamps
    end
  end

  def self.down
    drop_table :group_leaders
  end
end
