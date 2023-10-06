class CreateCosponsorships < ActiveRecord::Migration[4.2]
  def self.up
    create_table :cosponsorships do |t|
      t.integer :legislation_id
      t.integer :chamber_role_id
      t.timestamps
    end
  end

  def self.down
    drop_table :cosponsorships
  end
end
