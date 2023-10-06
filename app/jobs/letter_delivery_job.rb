# frozen_string_literal: true
class LetterDeliveryJob < ApplicationJob

  def perform

    Course.active.each do |course|
      Time.zone = course.time_zone

      course.chambers.each do |chamber|
        chamber.letters.unnotified.each do |pending_letter|

          #for each recipient send an email letting them know "you've got mail!"
          pending_letter.letter_user_recipients.each do |letter_user_recipient|
            begin
              letter_user_recipient.deliver
            rescue => e
              log.error( e.message )
            end
          end

          #mark these messages as notified
          pending_letter.update(notified: true)

        end
      end
    end
  end

  def log
    @log ||= Logger.new( "#{Rails.root}/log/letter_delivery_job.log" )
  end
end