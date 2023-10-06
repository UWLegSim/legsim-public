class CreateLetterGroupRecipients < ActiveRecord::Migration[4.2]
  def self.up
    create_table :letter_group_recipients do |t|
      t.integer :letter_id
      t.integer :group_id
      t.timestamps
    end
  end

  def self.down
    drop_table :letter_group_recipients
  end
end
