class ChangeLeadershipNominations < ActiveRecord::Migration[4.2]
  def self.up
  	drop_table :leadership_nominations
    drop_table :leadership_endorsements
  	create_table :leadership_nominations do |t|
  		t.integer :chamber_id
      t.integer :chamber_role_id
  		t.integer :endorsements
  		t.timestamps
  	end
  end

  def self.down
  	drop_table :leadership_nominations
  	create_table :leadership_nominations do |t|
      t.integer :group_id
      t.string  :position
      t.boolean :open
      t.timestamps
    end

    create_table :leadership_endorsements do |t|
      t.integer :leadership_nomination_id
      t.integer :chamber_role_id
      t.integer :endorsed_chamber_role_id
      t.timestamps
    end
  end
end
