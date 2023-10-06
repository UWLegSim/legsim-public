class Admin::CaucusesController < AdminController

  def index
    @page_title = "Caucus Management"
    @caucuses = current_chamber.caucuses
  end

  def show
    @caucus = Caucus.find( params[:id] )
    @page_title = "Manage Caucus"
    @page_description = @caucus.name
  end

  def new
    @page_title = "Create New Caucus"
    @caucus = current_chamber.caucuses.new
  end

  def create
    @caucus = Caucus.new( caucus_params )
    if @caucus.save
      flash_message("#{@caucus.name} has been created")
      redirect_to( admin_caucuses_path )
    else
      render(:action => :new)
    end
  end

  def edit
    @caucus = Caucus.find( params[:id] )
    @page_title = "Edit Caucus"
    @page_description = @caucus.name
  end

  def update
    @caucus = Caucus.find(params[:id])
    if @caucus.update( caucus_params )
      flash_message("Caucus Information Updated")
      redirect_to( manage_info_caucus_path(@caucus) )
    else
      @page_title = "Caucus Information Management"
      @page_description = @caucus.name
      render(:action => :edit)
    end
  end

  def mass_delete
    if params[:group_ids].nil? or params[:group_ids].empty?
      flash_message("No caucuses were selected.",:error)
    else
      params[:group_ids].each do |id|
        Caucus.destroy( id )
      end
      flash_message("#{ActionController::Base.helpers.pluralize(params[:group_ids].count, 'caucus')} deleted.")
    end
    redirect_to( admin_caucuses_path )
  end

  def destroy
    caucus = Caucus.destroy( params[:id] )
    flash_message("#{caucus.name} deleted.")
    redirect_to( admin_caucuses_path )
  end

  def download_stats
    @caucus = Caucus.find(params[:id])
    send_data @caucus.to_csv, :filename => @caucus.name.parameterize + '.csv'
  end

  def update_leadership
    @caucus = Caucus.find(params[:id])
    @caucus.assign_primary_group_leader( params[:primary_leader] )

    flash_message("Caucus Leadership Updated")
    redirect_to( admin_caucus_path( @caucus ) )
  end

  def add_members
    @caucus = Caucus.find(params[:id])
    params[:chamber_role_ids].each do |chamber_role_id|
      @caucus.add_member( chamber_role_id )
    end

    flash_message("Caucus Members Added")
    redirect_to( admin_caucus_path( @caucus ) )
  end

  def remove_members
    @caucus = Caucus.find(params[:id])
    params[:chamber_role_ids].each do |chamber_role_id|
      @caucus.remove_member( chamber_role_id )
    end

    flash_message("Caucus Members Removed")
    redirect_to( admin_caucus_path( @caucus ) )
  end

  private

  def caucus_params
    params.require(:caucus).permit!
  end

end
