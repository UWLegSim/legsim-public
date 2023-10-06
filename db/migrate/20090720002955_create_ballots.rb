class CreateBallots < ActiveRecord::Migration[4.2]
  def self.up
    create_table :ballots do |t|
      t.string  :choice
      t.integer :vote_id
      t.integer :chamber_role_id
      t.timestamps
    end
  end

  def self.down
    drop_table :ballots
  end
end
