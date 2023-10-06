class Admin::ReferralsController < AdminController

  def index
    @page_title = "Referral Management"

    @legislative_types = current_chamber.legislative_types

#     @floor = current_chamber.floor( :include => :referrals )
#     @committees = current_chamber.committees( :include => :referrals )
#     @parties = current_chamber.parties( :include => :referrals )
#     @caucuses = current_chamber.caucuses( :include => :referrals )
  end

  def show
    @committee = Committee.find( params[:id] )
    @page_title = "Manage Committee"
    @page_description = @committee.name
  end

  def new
    @page_title = "Create New Committee"
    @committee = current_chamber.committees.new
  end

  def create
    @committee = Committee.new( committee_params )
    if @committee.save
      flash_message("#{@committee.name} has been created")
      redirect_to( admin_committees_path )
    else
      render(:action => :new)
    end
  end

  def mass_delete
    if params[:group_ids].nil? or params[:group_ids].empty?
      flash_message("No committees were selected.",:error)
    else
      params[:group_ids].each do |id|
        Committee.destroy( id )
      end
      flash_message("#{ActionController::Base.helpers.pluralize(params[:group_ids].count, 'committee')} deleted.")
    end
    redirect_to( admin_committees_path )
  end

  def destroy
    committee = Committee.destroy( params[:id] )
    flash_message("#{committee.name} deleted.")
    redirect_to( admin_committees_path )
  end

  def edit
    @committee = Committee.find( params[:id] )
    @page_title = "Edit Committee"
    @page_description = @committee.name
  end

  def update
    @committee = Committee.find(params[:id])
    if @committee.update(committee_params)
      flash_message("Committee Information Updated")
      redirect_to( admin_committees_path )
    else
      @page_title = "Edit Committee"
      @page_description = @committee.name
      render(:action => :edit)
    end
  end

  def download_stats
    @committee = Committee.find(params[:id])
    send_data @committee.to_csv, :filename => @committee.name.parameterize + '.csv'
  end

  def update_leadership
    @committee = Committee.find(params[:id])
    @committee.assign_primary_group_leader( primary_leader_params )

    flash_message("Committee Leadership Updated")
    redirect_to( admin_committee_path( @committee ) )
  end

  def add_members
    @committee = Committee.find(params[:id])
    params[:chamber_role_ids].each do |chamber_role_id|
      @committee.add_member( chamber_role_id )
    end

    flash_message("Committee Members Added")
    redirect_to( admin_committee_path( @committee ) )
  end

  def remove_members
    @committee = Committee.find(params[:id])
    params[:chamber_role_ids].each do |chamber_role_id|
      @committee.remove_member( chamber_role_id )
    end

    flash_message("Committee Members Removed")
    redirect_to( admin_committee_path( @committee ) )
  end

  def committee_params
    params.require(:committee).permit!
  end

  def primary_leader_params
    params.require(:primary_leader).permit!
  end
end
