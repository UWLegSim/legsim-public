class AddCommentCounterToDiscussions < ActiveRecord::Migration[4.2]
  def self.up
    add_column :discussions, :comments_count, :integer
  end

  def self.down
    remove_column :discussions, :comments_count
  end
end
