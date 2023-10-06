class CreateLeadershipNominations < ActiveRecord::Migration[4.2]
  def self.up
    create_table :leadership_nominations do |t|
      t.integer :group_id
      t.string  :position
      t.boolean :open
      t.timestamps
    end
  end

  def self.down
    drop_table :leadership_nominations
  end
end
