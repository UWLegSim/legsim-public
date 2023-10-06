class ChangeVotesChoiceToPreference < ActiveRecord::Migration[4.2]
  def self.up
    rename_column :ballots, :choice, :preference
  end

  def self.down
    rename_column :ballots, :preference, :choice
  end
end
