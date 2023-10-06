class CreateContents < ActiveRecord::Migration[4.2]
  def self.up
    create_table :contents do |t|
      t.string  :reference
      t.text    :copy
      t.integer :chamber_id
      t.timestamps
    end
  end

  def self.down
    drop_table :contents
  end
end
