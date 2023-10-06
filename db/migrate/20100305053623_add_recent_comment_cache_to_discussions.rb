class AddRecentCommentCacheToDiscussions < ActiveRecord::Migration[4.2]
  def self.up
    add_column :discussions, :last_comment_id, :integer
    add_column :discussions, :last_comment_at, :datetime
  end

  def self.down
    remove_column :discussions, :last_comment_id
    remove_column :discussions, :last_comment_at
  end
end
