class LetterGroupRecipient < ActiveRecord::Base

  belongs_to :letter
  belongs_to :group

  has_many :letter_user_recipients

  def distribute

    group.membership.each do |member|
      letter_user_recipients.create!( :chamber_role => member, :letter => letter )
    end

  end

end
