class CreateReports < ActiveRecord::Migration[4.2]
  def self.up
    create_table :reports do |t|
      t.integer :referral_id
      t.integer :reported_text_id
      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end
end
