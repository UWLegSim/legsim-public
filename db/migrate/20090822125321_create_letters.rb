class CreateLetters < ActiveRecord::Migration[4.2]
  def self.up
    create_table :letters do |t|
      t.string :subject
      t.text :message
      t.integer :chamber_role_id
      t.boolean :notified
      t.timestamps
    end
  end

  def self.down
    drop_table :letters
  end
end
