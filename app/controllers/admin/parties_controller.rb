class Admin::PartiesController < AdminController

  def index
    @page_title = "Party Management"
    @parties = current_chamber.parties
  end

  def show
    @party = Party.find( params[:id] )
    @page_title = "Manage Party"
    @page_description = @party.name
  end

  def new
    @page_title = "Create New Party"
    @party = current_chamber.parties.new
  end

  def create
    @party = Party.new( party_params )
    if @party.save
      flash_message("#{@party.name} has been created")
      redirect_to( admin_parties_path )
    else
      render(:action => :new)
    end
  end

  def edit
    @party = Party.find( params[:id] )
    @page_title = "Edit Party"
    @page_description = @party.name
  end

  def update
    @party = Party.find(params[:id])
    if @party.update(party_params)
      flash_message("Party Information Updated")
      redirect_to( admin_parties_path )
    else
      @page_title = "Edit Paty"
      @page_description = @party.name
      render(:action => :edit)
    end
  end

  def mass_delete
    if params[:group_ids].nil? or params[:group_ids].empty?
      flash_message("No parties were selected.",:error)
    else
      params[:group_ids].each do |id|
        Party.destroy( id )
      end
      flash_message("#{ActionController::Base.helpers.pluralize(params[:group_ids].count, 'party')} deleted.")
    end
    redirect_to( admin_parties_path )
  end

  def destroy
    party = Party.destroy( params[:id] )
    flash_message("#{party.name} deleted.")
    redirect_to( admin_parties_path )
  end

  def download_stats
    @party = Party.find(params[:id])
    send_data @party.to_csv, :filename => @party.name.parameterize + '.csv'
  end

  def update_leadership
    @party = Party.find(params[:id])
    @party.assign_primary_group_leader( params[:primary_leader] )

    flash_message("Party Leadership Updated")
    redirect_to( admin_party_path( @party ) )
  end

  def add_members
    @party = Party.find(params[:id])
    params[:chamber_role_ids].each do |chamber_role_id|
      @party.add_member( chamber_role_id )
    end

    flash_message("Party Members Added")
    redirect_to( admin_party_path( @party ) )
  end

  def remove_members
    @party = Party.find(params[:id])
    params[:chamber_role_ids].each do |chamber_role_id|
      @party.remove_member( chamber_role_id )
    end

    flash_message("Party Members Removed")
    redirect_to( admin_party_path( @party ) )
  end

  private

  def party_params
    params.require(:party).permit!
  end
end
