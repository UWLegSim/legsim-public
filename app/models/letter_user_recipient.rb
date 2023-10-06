class LetterUserRecipient < ActiveRecord::Base

  belongs_to :letter
  belongs_to :chamber_role

  belongs_to :letter_group_recipient, optional: true
  belongs_to :letter_meta_group_recipient, optional: true

  def deliver

    mail = Mail.new
    
    mail.from = letter.chamber_role.dear_colleague_envilope_address
    mail.sender = 'LegSim Clerk <clerk@legsim.org>'
    mail.reply_to = 'No Reply <no-reply@legsim.org>'
    mail.to = chamber_role.envilope_address
    mail.subject = "[LegSim] #{subject}"
    mail.body = message_body

    # mail.delivery_method :exim, :location => "/usr/bin/exim"
    mail.deliver

  end

  def message_body

    msg = <<END_OF_MESSAGE
#{letter.message}
---
Reply: https://www.legsim.org/letters/#{letter.id}/reply
Reply All: https://www.legsim.org/letters/#{letter.id}/reply_all
Delivered To: #{letter.recipient_string}
Chamber: #{chamber_role.chamber.course_title}
END_OF_MESSAGE

    msg

  end

  def subject

    if letter_group_recipient
      "#{letter.subject} (#{letter_group_recipient.group.name})"
    elsif letter_meta_group_recipient
      "#{letter.subject} (#{letter_meta_group_recipient.name})"
    else
      letter.subject
    end

  end

end
