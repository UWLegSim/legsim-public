class Admin::ConstituenciesController < AdminController
  
  def index
    @page_title = "Constituency Management"
    @constituencies = current_chamber.constituencies
  end

  def show
    @constituency = Constituency.find( params[:id] )
    @page_title = "Manage Constituency"
    @page_description = @constituency.name
  end

  def new
    @page_title = "Create New Constituency"
    @constituency = current_chamber.constituencies.new
  end

  def create
    @constituency = Constituency.new( constituency_params )
    if @constituency.save
      flash_message("#{@constituency.name} has been created")
      redirect_to( admin_constituencies_path )
    else
      render(:action => :new)
    end
  end

  def edit
    @constituency = Constituency.find( params[:id] )
    @page_title = "Edit Constituency"
    @page_description = @constituency.name
  end

  def update
    @constituency = Constituency.find(params[:id])
    if @constituency.update(constituency_params)
      flash_message("Constituency Information Updated")
      redirect_to( admin_constituencies_path )
    else
      @page_title = "Edit Constituency"
      @page_description = @constituency.name
      render(:action => :edit)
    end
  end

  def mass_delete
    if params[:constituency_ids].nil? or params[:constituency_ids].empty?
      flash_message("No constituencies were selected.",:error)
    else
      params[:constituency_ids].each do |id|
        Constituency.destroy( id )
      end
      flash_message("#{ActionController::Base.helpers.pluralize(params[:constituency_ids].count, 'constituency')} deleted.")
    end
    redirect_to( admin_constituencies_path )
  end

  def destroy
    constituency = Constituency.destroy( params[:id] )
    flash_message("#{constituency.name} deleted.")
    redirect_to( admin_constituencies_path )
  end

  def constituency_params
    params.require(:constituency).permit!
  end
end
