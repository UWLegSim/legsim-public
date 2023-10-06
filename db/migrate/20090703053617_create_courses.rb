class CreateCourses < ActiveRecord::Migration[4.2]
  def self.up
    create_table :courses do |t|
      t.string  :name
      t.integer :institution_id
      t.timestamps
    end
  end

  def self.down
    drop_table :courses
  end
end
