class CommitteesController < ApplicationController

  def manage
    @committee = Committee.find( params[:id] )
    @page_title = "Committee Management"
    @page_description = @committee.name
  end

  def propose_special_rule
    committee = Committee.find( params[:id] )

    legislation = Legislation.find( params[:legislation_ids].split(',') )

    legislative_references = legislation.collect {|leg| leg.reference }

    special_rule = Legislation.create!(
      :name             => "Special Rule for #{legislative_references.join(', ')}",
      :sponsor          => @current_chamber_role,
      :legislative_type => @current_chamber.legislative_type_for_special_rule,
      :status           => "draft",
      :submission_text  => LegislativeText.new(
        :primary_text => params[:draft_rule]
      )
    )

    legislation.each do |leg|
      special_rule.relate( :target => leg, :relation => "special_rule" )
    end

    referral = special_rule.referrals.create!(
      :group         => committee,
      :referrer      => @current_chamber_role,
      :referred_text => special_rule.submission_text,
      :status        => 'hearing',
      :priority      => 'rules'
    )

    referral.manage_discussion( :chamber_role => @current_chamber_role )

    flash_message("Special Rule has been proposed to the committee for consideration")
    redirect_to( referral_path(referral) )

  end

  def draft_special_rule
    @committee = Committee.find( params[:id] )
    @page_title = "Draft Special Rule"
    @page_description = @committee.name
  end

  def generate_special_rule
    @committee = Committee.find( params[:id] )

    @legislation = params[:legislation_ids].split(',').collect do |legislation_id|
      Legislation.find(legislation_id)
    end
  end

  def manage_discussions
    @committee = Committee.find( params[:id] )
    @page_title = "Committee Discussion Management"
    @page_description = @committee.name
  end

  def manage_referrals
    @committee = Committee.find( params[:id] )
    @page_title = "Committee Referral Management"
    @page_description = @committee.name
  end

  def manage_info
    @committee = Committee.find( params[:id] )
    @page_title = "Committee Information Management"
    @page_description = @committee.name
  end

  def membership_requests
    @page_title = "Committee Requests"
    @committees = current_chamber.committees
    @chamber_role = current_chamber_role
  end

  def update_membership_requests

    unless GroupMembershipRequest.find_by_group_id_and_chamber_role_id_and_rank(params[:rank_1],current_chamber_role.id,1)
      old_request = current_chamber_role.committee_request_by_rank(1)
      old_request.destroy if old_request
      GroupMembershipRequest.create!(
        :group_id => params[:rank_1],
        :chamber_role => current_chamber_role,
        :rank => 1
      ) unless params[:rank_1].blank?
    end

    unless GroupMembershipRequest.find_by_group_id_and_chamber_role_id_and_rank(params[:rank_2],current_chamber_role.id,1)
      old_request = current_chamber_role.committee_request_by_rank(2)
      old_request.destroy if old_request
      GroupMembershipRequest.create!(
        :group_id => params[:rank_2],
        :chamber_role => current_chamber_role,
        :rank => 2
      ) unless params[:rank_2].blank?
    end

    display_message("Your Membership Requests have been updated.")

    redirect_to( membership_requests_committees_path )
  end

  def manage_votes
    @committee = Committee.find( params[:id] )
    @page_title = "Committee Vote Management"
    @page_description = @committee.name
  end

  def index
    @committees = current_chamber.committees
    @page_title = 'Committee Directory'
  end

  def show
    @committee = Committee.find( params[:id] )
    @page_title = @committee.name
  end

  def new
    @committee = current_chamber.committees.new
  end

  def create
    @committee = Committee.new( committee_params )
    @committee.save ? redirect_to( @committee ) : render(:action => :new)
  end

  def edit
    @committee = Committee.find( params[:id] )
  end

  def update
    @committee = Committee.find(params[:id])
    if @committee.update( committee_params )
      flash_message("Committee Information Updated")
      redirect_to( manage_info_committee_path(@committee) )
    else
      @page_title = "Committee Information Management"
      @page_description = @committee.name
      render(:action => :manage_info)
    end
  end

  def destroy
    Committee.destroy( params[:id] )
    redirect_to( committees_path )
  end

  private
    
  def committee_params
    params.require(:committee).permit!
  end

end
