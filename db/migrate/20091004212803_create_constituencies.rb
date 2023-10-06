class CreateConstituencies < ActiveRecord::Migration[4.2]
  def self.up
    create_table :constituencies do |t|
      t.string  :name
      t.string  :abbr
      t.string  :map_url
      t.integer :vote_weight
      t.integer :chamber_id
      t.timestamps
    end
  end

  def self.down
    drop_table :constituencies
  end
end
