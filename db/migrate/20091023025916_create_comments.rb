class CreateComments < ActiveRecord::Migration[4.2]
  def self.up
    create_table :comments do |t|
      t.integer :discussion_id
      t.integer :chamber_role_id
      t.text    :content
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
