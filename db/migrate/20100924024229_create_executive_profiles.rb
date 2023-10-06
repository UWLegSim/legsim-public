class CreateExecutiveProfiles < ActiveRecord::Migration[4.2]
  def self.up
    create_table :executive_profiles do |t|
      t.integer :executive_id
      t.column  :personal_statement, :text
      t.column  :priorities, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :executive_profiles
  end
end
