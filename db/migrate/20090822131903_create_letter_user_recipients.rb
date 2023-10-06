class CreateLetterUserRecipients < ActiveRecord::Migration[4.2]
  def self.up
    create_table :letter_user_recipients do |t|
      t.integer :letter_id
      t.integer :chamber_role_id
      t.integer :letter_group_recipient_id, :null => true
      t.integer :letter_meta_group_recipient_id, :null => true
      t.timestamps
    end
  end

  def self.down
    drop_table :letter_user_recipients
  end
end
