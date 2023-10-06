class AddStatusToReports < ActiveRecord::Migration[4.2]
  def self.up
    add_column :reports, :status, :string, :default => 'published'
  end

  def self.down
    remove_column :reports, :status
  end
end
