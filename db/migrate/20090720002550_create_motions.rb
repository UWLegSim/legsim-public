class CreateMotions < ActiveRecord::Migration[4.2]
  def self.up
    create_table :motions do |t|
      t.string  :action
      t.text    :text
      t.integer :referral_id
      t.integer :chamber_role_id
      t.timestamps
    end
  end

  def self.down
    drop_table :motions
  end
end
