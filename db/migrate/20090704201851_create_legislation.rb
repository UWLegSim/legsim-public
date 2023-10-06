class CreateLegislation < ActiveRecord::Migration[4.2]
  def self.up
    create_table :legislation do |t|
      t.string  :name
      t.integer :number
      t.integer :legislative_type_id
      t.integer :submission_text_id
      t.timestamps
    end
  end

  def self.down
    drop_table :legislation
  end
end
