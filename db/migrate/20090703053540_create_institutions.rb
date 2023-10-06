class CreateInstitutions < ActiveRecord::Migration[4.2]
  def self.up
    create_table :institutions do |t|
      t.string  :name
      t.timestamps
    end
  end

  def self.down
    drop_table :institutions
  end
end
