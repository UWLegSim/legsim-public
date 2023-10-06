class CreateLegislationRelationships < ActiveRecord::Migration[4.2]
  def self.up
    create_table :legislation_relationships do |t|
      t.integer :actor_id
      t.integer :target_id
      t.string  :relation
      t.timestamps
    end
  end

  def self.down
    drop_table :legislation_relationships
  end
end
