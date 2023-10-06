class CreateLetterMetaGroupRecipients < ActiveRecord::Migration[4.2]
  def self.up
    create_table :letter_meta_group_recipients do |t|
      t.integer :letter_id
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :letter_meta_group_recipients
  end
end
