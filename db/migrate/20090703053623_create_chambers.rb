class CreateChambers < ActiveRecord::Migration[4.2]
  def self.up
    create_table :chambers do |t|
      t.string  :name
      t.integer :course_id
      t.timestamps
    end
  end

  def self.down
    drop_table :chambers
  end
end
