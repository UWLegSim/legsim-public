class CreateSponsorships < ActiveRecord::Migration[4.2]
  def self.up
    create_table :sponsorships do |t|
      t.integer :legislation_id
      t.integer :chamber_role_id
      t.timestamps
    end
  end

  def self.down
    drop_table :sponsorships
  end
end
