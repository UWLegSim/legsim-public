class AddBlindToLetterUserRecipient < ActiveRecord::Migration[4.2]
  def self.up
    add_column :letter_user_recipients, :blind, :boolean, :default => 0
  end

  def self.down
    drop_column :letter_user_recipients, :blind
  end
end
