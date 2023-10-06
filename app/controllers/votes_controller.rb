class VotesController < ApplicationController

  def cancel

    
    @vote = Vote.find( params[:id] )
    @motion = @vote.motion
    @vote.cancel

    flash_message("#{@vote.title} vote has been cancelled.")
    redirect_to_group_manage_votes_page( @motion.referral.group )

  end

  def index

    @group = Group.find( params[:group_id] )

    @page_title = @group.name
    @page_description = "Previous Votes"

  end

  def show

    @vote = Vote.find( params[:id] )

    @page_title = "Vote Regarding #{@vote.referral.legislation.reference}"
    @page_description = @vote.motion.action.titleize
  end

  def amendment_options
    @referral = Referral.find( params[:referral_id] )
  end

  def amendment_text
    amendment = Amendment.find( params[:amendment_id] )
    render plain: amendment.text
  end

  def final_passage_options
    @referral = Referral.find( params[:referral_id] )
  end

  def final_passage_text
    legislative_text = LegislativeText.find( params[:legislative_text_id] )
    render plain: legislative_text.primary_text
  end

  def cloture_text
    referral = Referral.find( params[:referral_id] )
    render plain:  "Motion to bring to a close the debate upon #{referral.votes.filibuster.last.motion.title}."
  end

  def report_text
    referral = Referral.find( params[:referral_id] )
    render plain: "Motion to a report #{referral.legislation.title} from the #{referral.group.name} and adopt proposed #{referral.group.type} Report."
  end

  def create

    if params[:motion]
      @motion = Motion.new( motion_params )
      @motion.chamber_role = @current_chamber_role
      @motion.limited_debate = true if @motion.action == 'unanimous_consent_agreement'
      @motion.save
    end

    params[:vote][:start_at] = Time.zone.parse("#{params[:vote][:start_at_date]} #{params[:vote][:start_at_time]}")
    params[:vote][:finish_at] = Time.zone.parse("#{params[:vote][:finish_at_date]} #{params[:vote][:finish_at_time]}")

    params[:vote].delete( :start_at_date )
    params[:vote].delete( :start_at_time )
    params[:vote].delete( :finish_at_date )
    params[:vote].delete( :finish_at_time )

    @vote = Vote.new( vote_params)
    @vote.motion = @motion
    @vote.outcome = 'none'
    @vote.threshold = '500' if @motion.action == 'motion_to_proceed'
    @vote.threshold = '1000' if @motion.action == 'unanimous_consent_agreement'

    @vote.save
    @vote.update_calendar

    if @motion.action == 'passage'
      @motion.referral.update!( :status => 'scheduled' )
    end

    flash_message("#{@vote.title} vote scheduled to start at #{@vote.start_at.to_s(:long_with_time)} and end at #{@vote.finish_at.to_s(:long_with_time)}")
    redirect_to_group_manage_votes_page( @motion.referral.group )

  end

  def edit

    @vote = Vote.find( params[:id] )
    @motion = @vote.motion

    @page_title = @motion.legislation.reference
    @page_description = "Revise Vote Schedule"

  end

  def edit_previous

    @vote = Vote.find( params[:id] )
    @motion = @vote.motion

    @page_title = @motion.legislation.reference
    @page_description = "Revise Previous Vote"

  end


  def update

    params[:vote][:start_at] = Time.zone.parse("#{params[:vote][:start_at_date]} #{params[:vote][:start_at_time]}")
    params[:vote].delete( :start_at_date )
    params[:vote].delete( :start_at_time )

    if params[:vote][:finish_at_date] and params[:vote][:finish_at_time]
      params[:vote][:finish_at] = Time.zone.parse("#{params[:vote][:finish_at_date]} #{params[:vote][:finish_at_time]}")
      params[:vote].delete( :finish_at_date )
      params[:vote].delete( :finish_at_time )
    else
      params[:vote][:finish_at] = params[:vote][:start_at]
    end

    @vote = Vote.find( params[:id] )
    @vote.update!( vote_params)
    @vote.motion.update!( motion_params )

    flash_message("#{@vote.title} vote updated to start at #{@vote.start_at.to_s(:long_with_time)} and end at #{@vote.finish_at.to_s(:long_with_time)}")
    redirect_to edit_vote_path( @vote )
#     redirect_to manage_votes_floor_path( @vote.motion.referral.group )

  end

  def new

    referral = Referral.find( params[:referral_id] )
    @motion = Motion.new( :referral => referral )
    @motion.limited_debate = ( params[:cloture] ) ? true : false

    @vote = Vote.new
    @vote.start_at  = 1.hour.from_now
    @vote.finish_at = 25.hours.from_now
    @vote.status = 'pending'
    @vote.record_type = 'roll_call'
    @vote.threshold = ( params[:cloture] ) ? '600' : '500'
    @vote.absolute = ( params[:cloture] ) ? true : false

    @page_title = referral.legislation.reference
    @page_description = "#{referral.group.name} Vote Scheduling"

    if params[:cloture]
      @motion_options = [['Cloture','cloture']]
    elsif referral.group.is_floor?
      @motion_options = [['--',''],['Final Passage','passage'],['Amendment','amendment'],['General Motion','general']]
    else
      if referral.report
        @motion_options = [['--',''],["Adopt #{referral.group.type} Report",'report'],["#{referral.group.type} Amendment",'amendment'],['General Motion','general']]
      else
        @motion_options = [['--',''],["#{referral.group.type} Amendment",'amendment'],['General Motion','general']]
      end
    end

  end

  def update_previous

    params[:vote][:start_at] = Time.zone.parse("#{params[:vote][:start_at_date]} #{params[:vote][:start_at_time]}")
    params[:vote][:finish_at] = params[:vote][:start_at]

    params[:vote].delete( :start_at_date )
    params[:vote].delete( :start_at_time )

    @vote = Vote.find( params[:id] )
    @vote.update!( vote_params)
    @vote.motion.update!( motion_params )
    @vote.save
    @vote.update_calendar

    if @vote.record_type == 'roll_call'

      params[:roll_call][:member_id].each_pair do |member_id,preference|
        Ballot.find_or_create_by(chamber_role_id: member_id,vote_id: @vote.id).update!(
          :preference => preference
        )
      end

      @vote.recount
      @vote.calculate_outcome

    elsif @vote.record_type == 'division'

      @vote.yes_cache = params[:division][:yes]
      @vote.no_cache = params[:division][:no]
      @vote.present_cache = params[:division][:present]
      @vote.ballots.destroy_all

      @vote.calculate_outcome

    elsif @vote.record_type == 'voice_vote'

      @vote.outcome = params[:voice_vote][:outcome]
      @vote.yes_cache = 0
      @vote.no_cache = 0
      @vote.present_cache = 0
      @vote.ballots.destroy_all

    end

    @vote.save
    @vote.process_outcome

    if @vote.motion.action == 'passage'
      @vote.motion.referral.update!( :status => 'finished' )
    end

    flash_message("Previous #{@vote.title} vote updated.")
    redirect_to edit_previous_vote_path( @vote )

  end

  def create_previous

    if params[:motion]
      @motion = Motion.new( motion_params )
      @motion.chamber_role = @current_chamber_role
      @motion.limited_debate = true if @motion.action == 'unanimous_consent_agreement'
      @motion.save
    end

    params[:vote][:start_at] = Time.zone.parse("#{params[:vote][:start_at_date]} #{params[:vote][:start_at_time]}")
    params[:vote][:finish_at] = params[:vote][:start_at]

    params[:vote].delete( :start_at_date )
    params[:vote].delete( :start_at_time )

    @vote = Vote.new( vote_params)
    @vote.motion = @motion
    @vote.threshold = '500' if @motion.action == 'motion_to_proceed'
    @vote.threshold = '1000' if @motion.action == 'unanimous_consent_agreement'
    @vote.save
    @vote.update_calendar

    if @vote.record_type == 'roll_call'

      params[:roll_call][:member_id].each_pair do |member_id,preference|
        @vote.ballots.create!(
          :chamber_role_id => member_id,
          :preference => preference
        )
      end

      @vote.recount
      @vote.calculate_outcome

    elsif @vote.record_type == 'division'

      @vote.yes_cache = params[:division][:yes]
      @vote.no_cache = params[:division][:no]
      @vote.present_cache = params[:division][:present]

      @vote.calculate_outcome

    elsif @vote.record_type == 'voice_vote'

      @vote.outcome = params[:voice_vote][:outcome]

    end

    @vote.save
    @vote.process_outcome

    if @motion.action == 'passage'
      @motion.referral.update!( :status => 'finished' )
    end

    flash_message("Previous #{@motion.action.titleize} vote entered")
    redirect_to_group_manage_votes_page( @motion.referral.group )

  end

  def previous

    referral = Referral.find( params[:referral_id] )
    @motion = Motion.new( :referral => referral )
    @motion.limited_debate = ( params[:cloture] ) ? true : false

    @vote = Vote.new
    @vote.start_at  = Time.now
    @vote.status = 'finished'
    @vote.threshold = ( params[:cloture] ) ? '600' : '500'
    @vote.absolute = ( params[:cloture] ) ? true : false
    @vote.absolute = ( params[:cloture] ) ? true : false

    if params[:cloture]
      @motion_options = [['Cloture','cloture']]
    elsif referral.group.is_floor?
      @motion_options = [['--',''],['Final Passage','passage'],['Amendment','amendment'],['General Motion','general']]
    else
      if referral.report
        @motion_options = [['--',''],["Adopt #{referral.group.type} Report",'report'],["#{referral.group.type} Amendment",'amendment'],['General Motion','general']]
      else
        @motion_options = [['--',''],["#{referral.group.type} Amendment",'amendment'],['General Motion','general']]
      end
    end

    @page_title = referral.legislation.reference
    @page_description = "Enter Previous Vote"

  end

  def vote_params
    params.require(:vote).permit!
  end

  def motion_params
    params.require(:motion).permit!
  end

  private

  def redirect_to_group_manage_votes_page( group )

    if group.is_floor?
      redirect_to manage_votes_floor_path( group )
    elsif group.is_committee?
      redirect_to manage_votes_committee_path( group )
    elsif group.is_caucus?
      redirect_to manage_votes_caucus_path( group )
    elsif group.is_party?
      redirect_to manage_votes_party_path( group )
    end

  end

end
