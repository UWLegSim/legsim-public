class CreateCalendars < ActiveRecord::Migration[4.2]
  def self.up
    create_table :calendars do |t|
      t.string  :name
      t.text    :description
      t.integer :group_id
      t.timestamps
    end
  end

  def self.down
    drop_table :calendars
  end
end
