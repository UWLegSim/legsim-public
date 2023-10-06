class CreateTutorials < ActiveRecord::Migration[4.2]
  def self.up
    create_table :tutorials do |t|
      t.string  :title
      t.text    :content
      t.string  :summary
      t.integer :position
      t.integer :chamber_id
      t.timestamps
    end
  end

  def self.down
    drop_table :tutorials
  end
end
