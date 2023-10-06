class AddChamberIdAndGroupIdToVote < ActiveRecord::Migration[4.2]
  def self.up
    add_column :votes, :group_id, :integer
    add_column :votes, :chamber_id, :integer

    Vote.all.each do |vote|
      if vote.motion and vote.motion.referral and vote.motion.referral.group
        vote.group = vote.motion.referral.group
        vote.chamber = vote.motion.referral.group.chamber if vote.motion.referral.group.chamber
        vote.save
      end
    end
  end

  def self.down
    remove_column :votes, :group_id
    remove_column :votes, :chamber_id
  end
end
