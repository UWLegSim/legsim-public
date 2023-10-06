class AddUniquenessConstraintsToBallots < ActiveRecord::Migration[6.0]
  def up
    execute 'CREATE TABLE tmp_ballots SELECT * FROM ballots;'
    execute 'TRUNCATE TABLE ballots;'
    execute 'ALTER TABLE ballots ADD UNIQUE INDEX chamber_role_id_and_vote_it (chamber_role_id,vote_id);'
    execute 'INSERT IGNORE INTO ballots SELECT * from tmp_ballots;'
    execute 'DROP TABLE tmp_ballots;'
  end

  def down

  end
end
