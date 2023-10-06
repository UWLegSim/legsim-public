class CreateAuthorizationCodes < ActiveRecord::Migration[4.2]
  def self.up
    create_table :authorization_codes do |t|
      t.integer :chamber_id
      t.string  :chamber_role_type
      t.string  :code
      t.boolean :active
      t.timestamps
    end
  end

  def self.down
    drop_table :authorization_codes
  end
end
