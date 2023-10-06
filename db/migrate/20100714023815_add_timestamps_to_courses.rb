class AddTimestampsToCourses < ActiveRecord::Migration[4.2]
  def self.up
    add_column :courses, :start_at, :timestamp
    add_column :courses, :finish_at, :timestamp
    add_column :courses, :archive_at, :timestamp
    add_column :courses, :status, :string
    add_column :courses, :email, :string
    add_column :courses, :time_zone, :string
  end

  def self.down
    remove_column :courses, :start_at
    remove_column :courses, :finish_at
    remove_column :courses, :archive_at
    remove_column :courses, :status
    remove_column :courses, :email
    remove_column :courses, :time_zone
  end
end
