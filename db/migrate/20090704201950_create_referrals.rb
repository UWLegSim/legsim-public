class CreateReferrals < ActiveRecord::Migration[4.2]
  def self.up
    create_table :referrals do |t|
      t.integer :legislation_id
      t.integer :group_id
      t.integer :referrer_id
      t.integer :referred_text_id
      t.string  :status
      t.integer :reading
      t.timestamps
    end
  end

  def self.down
    drop_table :referrals
  end
end
