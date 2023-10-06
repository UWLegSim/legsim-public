class CreateCalendarReferrals < ActiveRecord::Migration[4.2]
  def self.up
    create_table :calendar_referrals do |t|
      t.integer :calendar_id
      t.integer :referral_id
      t.integer :position
      t.timestamps
    end
  end

  def self.down
    drop_table :calendar_referrals
  end
end
