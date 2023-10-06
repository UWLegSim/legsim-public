class AddCreatorToDiscussions < ActiveRecord::Migration[4.2]
  def self.up
    add_column :discussions, :creator_id, :integer

    Discussion.all.each do |discussion|
      if discussion.group&.primary_group_leader
        discussion.creator = discussion.group&.primary_leader
        discussion.save
      end
    end
  end

  def self.down
    remove_column :discussions, :creator_id
  end
end
