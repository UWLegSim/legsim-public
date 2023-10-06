class AddChamberToLetters < ActiveRecord::Migration[4.2]
  def self.up
    add_column :letters, :chamber_id, :integer

    Letter.all.each do |letter|
      if letter.chamber_role and letter.chamber_role.chamber
        letter.chamber = letter.chamber_role.chamber
        letter.save
      end
    end
  end

  def self.down
    remove_column :letters, :chamber_id
  end
end
