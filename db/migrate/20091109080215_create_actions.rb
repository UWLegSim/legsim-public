class CreateActions < ActiveRecord::Migration[4.2]
  def self.up
    create_table :actions do |t|
      t.integer :user_id
      t.string  :request_type, length: 50
      t.timestamps
    end

    add_index( :actions, :request_type )
  end

  def self.down
    drop_table :actions
  end
end
