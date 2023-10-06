class ChambersController < ApplicationController

  def visit
    user = current_user
    chamber = Chamber.find( params[:id] )

    user.last_chamber = chamber
    user.save

    redirect_to( '/home' )
  end

  def index
    @chambers = Chamber.all
  end

  def show
    @chamber = Chamber.find( params[:id] )
  end

  def new
    if params[:course_id]
      @course = Course.find( params[:course_id] )
      @chamber = @course.chambers.new
    else
      @chamber = Chamber.new
    end
  end

  def create
    @chamber = Chamber.new( chamber_params )
    @chamber.save ? redirect_to( @chamber ) : render(:action => :new)
  end

  def edit
    @chamber = Chamber.find( params[:id] )
  end

  def update
    @chamber = Chamber.find(params[:id])
    @chamber.update( chamber_params ) ?
      redirect_to( @chamber ) : render(:action => :edit)
  end

  def destroy
    Chamber.destroy( params[:id] )
    redirect_to( chambers_path )
  end

  # leadership tools

  def manage
    @chamber = Chamber.find( params[:id] )
    authorize( :group => @chamber.floor )
    @page_title = "#{@chamber.title} Management"
    @page_description = "Manage the chamber's committees and legislation"
  end

  def edit_committee_referrals
    @chamber = Chamber.find( params[:id] )
    authorize( :group => @chamber.floor )
    @page_title = "Committee Referrals"
    @page_description = "Refer Legislation to Committees"
  end

  def update_committee_referrals

    @chamber = Chamber.find( params[:id] )
    authorize( :group => @chamber.floor )

    committee = Committee.find( params[:group_id] )

    if params['legislation_ids']
      params['legislation_ids'].each do |legislation_id|
        legislation = Legislation.find( legislation_id )
        committee.refer_legislation( legislation, params[:priority], @current_chamber_role )
      end
    end

    flash_message('Referrals issued')
    redirect_to( edit_committee_referrals_chamber_path( @chamber ) )

  end

  def undo_committee_referral

    @chamber = Chamber.find( params[:id] )
    authorize( :group => @chamber.floor )

    referral = Referral.find( params[:referral_id] )
    if referral
      referral.destroy
      flash_message('Referral has been undone',:notice)
    else
      flash_message('No such referral could be found',:error)
    end

    redirect_to( edit_committee_referrals_chamber_path( @chamber ) )

  end


  def edit_committee_primary_leaders
    @chamber = Chamber.find( params[:id] )
    authorize( :group => @chamber.floor )
    @page_title = "#{@chamber.title} Leadership"
    @page_description = "Designate the Chamber Leader and Committee Chairs"
  end

  def update_committee_primary_leaders
    @chamber = Chamber.find( params[:id] )
    authorize( :group => @chamber.floor )

    # process committees
    @chamber.committees.each do |committee|
      chamber_role_id = params["group_#{committee.id}"]

      if committee.primary_group_leader
        if chamber_role_id != ''
          committee.primary_group_leader.update!( :chamber_role_id => chamber_role_id )
        else
          committee.primary_group_leader.destroy
        end
      elsif chamber_role_id != ''
        committee.group_leaders.create!(
          :chamber_role_id => chamber_role_id,
          :title => 'Chair',
          :primary => true
        )
      end

    end

    # process floor
    chamber_role_id = params["group_#{@chamber.floor.id}"]

    if @chamber.floor.primary_group_leader
      if chamber_role_id != ''
        @chamber.floor.primary_group_leader.update!( :chamber_role_id => chamber_role_id )
      else
        @chamber.floor.primary_group_leader.destroy
      end
    elsif chamber_role_id != ''
      @chamber.floor.group_leaders.create!(
        :chamber_role_id => chamber_role_id,
        :title => @chamber.setting('chamber_leader_title'),
        :primary => true
      )
    end

    flash_message('Committee/Chamber Leadership Updated')

    redirect_to( edit_committee_primary_leaders_chamber_path( @chamber ) )

  end

  def edit_committee_assignments
    @chamber = Chamber.find( params[:id] )
    authorize( :group => @chamber.floor )
    @page_title = "#{@chamber.title} Committee Assignments"
    @page_description = "Designate members to the chamber's committees"
  end

  def update_committee_assignments
    @chamber = Chamber.find( params[:id] )
    authorize( :group => @chamber.floor )

    if params['add_chamber_role_ids']

      @committee = Committee.find( params['group_id'] )

      params['add_chamber_role_ids'].each do |chamber_role_id|
        @committee.add_member( chamber_role_id )
      end

      display_message('New Committee Assignments Added')
    elsif params['remove_group_membership_ids']
      params['remove_group_membership_ids'].each do |group_membership_id|
        GroupMembership.destroy( group_membership_id )
      end

      display_message('Committee Assignments Removed')
    end

    redirect_to( edit_committee_assignments_chamber_path( @chamber ) )

  end

  private
  
  def chamber_params
    params.require(:chamber).permit!
  end


end
