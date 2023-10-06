class CreateLeadershipEndorsements < ActiveRecord::Migration[4.2]
  def self.up
    create_table :leadership_endorsements do |t|
      t.integer :leadership_nomination_id
      t.integer :chamber_role_id
      t.integer :endorsed_chamber_role_id
      t.timestamps
    end
  end

  def self.down
    drop_table :leadership_endorsements
  end
end
