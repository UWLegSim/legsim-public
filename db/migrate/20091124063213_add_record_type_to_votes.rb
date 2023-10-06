class AddRecordTypeToVotes < ActiveRecord::Migration[4.2]
  def self.up
    add_column :votes, :record_type, :string
  end

  def self.down
    remove_column :votes, :record_type
  end
end
