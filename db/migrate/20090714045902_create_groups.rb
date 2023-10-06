class CreateGroups < ActiveRecord::Migration[4.2]
  def self.up
    create_table :groups do |t|
      t.string  :name
      t.string  :abbr
      t.string  :type
      t.text    :jurisdiction_description
      t.text    :issue_description
      t.integer :chamber_id
      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
