class LettersController < ApplicationController

  def index
    @offset = params[:offset] ? params[:offset].to_i : 0
    @limit = params[:limit] ? params[:limit].to_i : 10
    @letters = @current_chamber_role.received_letters.includes(:chamber_role).limit(@limit).offset(@offset)
    @letter_count = @current_chamber_role.received_letters.count
    @page_title = "Mailbox"
  end

  def sent
    @letters = @current_chamber_role.sent_letters
    @page_title = @current_chamber_role.title
    @page_description = "Sent Letters"
  end

  def create
    @letter = Letter.new( letter_params )
    @letter.notified = !current_chamber.setting('email_dear_colleague')
    @letter.save

    sent_to_administrators = false
    sent_to_instructors = false

    params[:chamber_role_ids].each do |chamber_role_id|
      @letter.letter_user_recipients.create(:chamber_role_id => chamber_role_id)
    end if params[:chamber_role_ids]

    params[:group_ids].each do |group_id|
      group_recipient = @letter.letter_group_recipients.create(:group_id => group_id)
      group_recipient.distribute
    end if params[:group_ids]

    params[:meta_group_ids].each do |meta_group_id|
      sent_to_administrators = true if meta_group_id == 'administrators'
      sent_to_instructors = true if meta_group_id == 'instructors'
      meta_group_recipient = @letter.letter_meta_group_recipients.create(:name => meta_group_id)
      meta_group_recipient.distribute
    end if params[:meta_group_ids]

    unless sent_to_administrators
      meta_group_recipient = @letter.letter_meta_group_recipients.create(:name => 'administrators')
      meta_group_recipient.blind_distribute
    end

    unless sent_to_instructors
      meta_group_recipient = @letter.letter_meta_group_recipients.create(:name => 'instructors')
      meta_group_recipient.blind_distribute
    end

    flash_message("Dear Colleague sent")
    redirect_to(@letter)
  end

  def new
    @reply_to = reply_to_hash

    @chamber = @current_chamber
    @letter = @current_chamber_role.sent_letters.new
    @page_title = "Compose Dear Colleague"
  end

  def reply_all
    @reply_to = reply_to_hash

    @chamber = @current_chamber
    sent_letter = Letter.find( params[:id] )
    @letter = @current_chamber_role.sent_letters.new
    @letter.subject = "Re: #{sent_letter.subject}"

    @reply_to[:chamber_role_ids][sent_letter.chamber_role_id] = true

    sent_letter.letter_user_recipients.each do |letter_user_recipient|
      if letter_user_recipient.letter_group_recipient_id.nil? and letter_user_recipient.letter_meta_group_recipient_id.nil?
        @reply_to[:chamber_role_ids][letter_user_recipient.chamber_role_id] = true
      end
    end

    sent_letter.letter_group_recipients.each do |letter_group_recipient|
      @reply_to[:group_ids][letter_group_recipient.group_id] = true
    end

    sent_letter.letter_meta_group_recipients.each do |letter_meta_group_recipient|
      @reply_to[:meta_group_ids][letter_meta_group_recipient.name] = true
    end

    render :action => 'new'
  end


  def reply
    @reply_to = reply_to_hash

    @chamber = @current_chamber
    sent_letter = Letter.find( params[:id] )
    @letter = @current_chamber_role.sent_letters.new
    @letter.subject = "Re: #{sent_letter.subject}"

    @reply_to[:chamber_role_ids][sent_letter.chamber_role_id] = true

    render :action => 'new'
  end

  def show
    @letter = Letter.find( params[:id] )
    @page_title = "Dear Colleague"
    @page_description = @letter.subject
  end

  def letter_params
    params.require(:letter).permit!
  end

  private

  def reply_to_hash
    {
      :chamber_role_ids => {},
      :group_ids => {},
      :meta_group_ids => {}
    }
  end

end
