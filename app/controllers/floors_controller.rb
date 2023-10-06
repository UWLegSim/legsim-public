class FloorsController < ApplicationController

  def generate_proceeding
    @floor = Floor.find( params[:id] )
    @proceeding_type = params[:proceeding_type]
    @referral = Referral.find( params[:referral_id] )
    @legislation = @referral.legislation
  end

  def new_proceeding
    @floor = Floor.find( params[:id] )
    @page_title = "Draft Floor Proceeding"
    @page_description = @floor.name

    @vote = Vote.new
    @vote.start_at  = 1.hour.from_now
    @vote.finish_at = 25.hours.from_now
    @vote.status = 'pending'
    @vote.record_type = 'roll_call'
  end

  def previous_proceeding
    @floor = Floor.find( params[:id] )
    @page_title = "Enter Previous Floor Proceeding"
    @page_description = @floor.name

    @vote = Vote.new
    @vote.start_at  = Time.now
    @vote.status = 'finished'
  end

  def propose_proceeding

    @floor = Floor.find( params[:id] )
    @legislation = Legislation.find( params[:legislation_id] )
    @referral = @legislation.referrals.floor.last

    @motion = Motion.new(
      :referral     => @referral,
      :action       => params[:proceeding_type],
      :text         => params[:draft_floor_proceeding],
      :chamber_role => @current_chamber_role
    )
    @motion.save

    params[:vote][:start_at] = Time.zone.parse("#{params[:vote][:start_at_date]} #{params[:vote][:start_at_time]}")
    params[:vote][:finish_at] = Time.zone.parse("#{params[:vote][:finish_at_date]} #{params[:vote][:finish_at_time]}")

    params[:vote].delete( :start_at_date )
    params[:vote].delete( :start_at_time )
    params[:vote].delete( :finish_at_date )
    params[:vote].delete( :finish_at_time )

    @vote = Vote.new(vote_params)
    @vote.motion = @motion
    @vote.outcome = 'none'

    flash_message("New Floor Proceeding Proposed")
    redirect_to( manage_proceedings_floor_path(@floor) )

  end

  def create_previous_proceeding

    @floor = Floor.find( params[:id] )
    @legislation = Legislation.find( params[:legislation_id] )
    @referral = @legislation.referrals.floor.last

    @motion = Motion.new(
      :referral     => @referral,
      :action       => params[:proceeding_type],
      :text         => params[:draft_floor_proceeding],
      :chamber_role => @current_chamber_role
    )
    @motion.save

    params[:vote][:start_at] = Time.zone.parse("#{params[:vote][:start_at_date]} #{params[:vote][:start_at_time]}")
    params[:vote][:finish_at] = params[:vote][:start_at]

    @vote = Vote.new(vote_params)
    @vote.motion = @motion

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

    flash_message("Previous Floor Proceeding Entered")
    redirect_to( manage_votes_floor_path(@floor) )

  end

  def show
    @floor = Floor.find( params[:id] )
    @page_title = "Floor"
    @page_description = @floor.name
  end

  def manage_info
    @floor = Floor.find( params[:id] )
    @page_title = "Floor Information Management"
    @page_description = @floor.name
  end

  def manage_referrals
    @floor = Floor.find( params[:id] )
    @page_title = "Debate Management"
    @page_description = @floor.name
  end

  def manage_votes
    @floor = Floor.find( params[:id] )
    @page_title = "Floor Vote Management"
    @page_description = @floor.name
  end

  def manage_proceedings
    @floor = Floor.find( params[:id] )
    @page_title = "Floor Proceedings Management"
    @page_description = @floor.name
  end

  def manage_calendars
    @floor = Floor.find( params[:id] )
    @page_title = "Calendar Management"
    @page_description = @floor.name
  end

  def update
    @floor = Floor.find( params[:id] )
    if @floor.update(floor_params)
      flash_message("Floor Information Updated")
      redirect_to( manage_info_floor_path(@floor) )
    else
      @page_title = "Floor Information Management"
      @page_description = @floor.name
      render(:action => :manage_info)
    end
  end

  def vote_params
    params.require(:vote).permit!
  end

  def floor_params
    params.require(:floor).permit!
  end
end
