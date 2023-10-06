class CreateMemberProfiles < ActiveRecord::Migration[4.2]
  def self.up
    create_table :member_profiles do |t|
      t.integer :member_id
      t.text    :personal_statement
      t.integer :constituency_id
      t.text    :constituency_description
      t.timestamps
    end
  end

  def self.down
    drop_table :member_profiles
  end
end
