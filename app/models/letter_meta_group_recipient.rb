class LetterMetaGroupRecipient < ActiveRecord::Base

  belongs_to :letter

  has_many :letter_user_recipients

  def distribute

    case name
      when 'chamber_leader'
        letter_user_recipients.create!(
          :chamber_role => chamber.floor.primary_leader,
          :letter       => letter
        ) if chamber.floor.primary_leader
      when 'committee_leaders'
        chamber.committees.each do |committee|
          letter_user_recipients.create!(
            :chamber_role => committee.primary_leader,
            :letter       => letter
          ) if committee.primary_leader
        end
      when 'party_leaders'
        chamber.parties.each do |party|
          letter_user_recipients.create!(
            :chamber_role => party.primary_leader,
            :letter       => letter
          ) if party.primary_leader
        end
      when 'caucus_leaders'
        chamber.caucuses.each do |caucus|
          letter_user_recipients.create!(
            :chamber_role => caucus.primary_leader,
            :letter       => letter
          ) if caucus.primary_leader
        end
      when 'administrators'
        chamber.administrators.each do |administrator|
          letter_user_recipients.create!(
            :chamber_role => administrator,
            :letter       => letter
          )
        end
    end

  end

  def blind_distribute

    case name
      when 'administrators'
        chamber.administrators.each do |administrator|
          letter_user_recipients.create!(
            :chamber_role => administrator,
            :letter       => letter,
            :blind        => true
          )
        end
    end

  end

  def chamber
    letter.chamber_role.chamber
  end

end
