class CreateVotes < ActiveRecord::Migration[4.2]
  def self.up
    create_table :votes do |t|
      t.string    :outcome
      t.string    :status
      t.datetime  :start
      t.datetime  :finish
      t.integer   :threshold
      t.integer   :motion_id
      t.integer   :yes_cache
      t.integer   :no_cache
      t.integer   :present_cache
      t.boolean   :absolute
      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
