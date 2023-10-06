class CreateLegislativeTexts < ActiveRecord::Migration[4.2]
  def self.up
    create_table :legislative_texts do |t|
      t.text    :primary_text
      t.text    :secondary_text
      t.timestamps
    end
  end

  def self.down
    drop_table :legislative_texts
  end
end
