class AddReferralIdToDiscussions < ActiveRecord::Migration[4.2]
  def self.up
    add_column :discussions, :referral_id, :integer
  end

  def self.down
    drop_column :discussions, :referral_id
  end
end
