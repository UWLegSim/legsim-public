class DropSponsorhips < ActiveRecord::Migration[4.2]
  def self.up
    add_column :legislation, :sponsor_id, :string
    drop_table :sponsorships
  end

  def self.down
    remove_column :legislation, :sponsor_id
    create_table :sponsorships do |t|
      t.integer :legislation_id
      t.integer :chamber_role_id
      t.timestamps
    end
  end
end
