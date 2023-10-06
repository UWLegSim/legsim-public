class CreateDiscussions < ActiveRecord::Migration[4.2]
  def self.up
    create_table :discussions do |t|
      t.integer :group_id
      t.string  :name
      t.boolean :open
      t.boolean :private
      t.timestamps
    end
  end

  def self.down
    drop_table :discussions
  end
end
