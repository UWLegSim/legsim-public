class Admin::SectionsController < AdminController

  def index
    @page_title = "Section Management"
    @sections = current_chamber.sections
  end

  def show
    @section = Section.find( params[:id] )
    @instructors = current_chamber.instructors + current_chamber.administrators

    @page_title = "Manage Section"
    @page_description = @section.name
  end

  def new
    @page_title = "Create New Section"
    @section = current_chamber.sections.new
  end

  def create
    @section = Section.new( section_params )
    if @section.save
      flash_message("#{@section.name} has been created")
      redirect_to( admin_sections_path )
    else
      render(:action => :new)
    end
  end

  def mass_delete
    if params[:group_ids].nil? or params[:group_ids].empty?
      flash_message("No sections were selected.",:error)
    else
      params[:group_ids].each do |id|
        Section.destroy( id )
      end
      flash_message("#{ActionController::Base.helpers.pluralize(params[:group_ids].count, 'section')} deleted.")
    end
    redirect_to( admin_sections_path )
  end

  def destroy
    section = Section.destroy( params[:id] )
    flash_message("#{section.name} deleted.")
    redirect_to( admin_sections_path )
  end

  def edit
    @section = Section.find( params[:id] )
    @page_title = "Edit Section"
    @page_description = @section.name
  end

  def update
    @section = Section.find(params[:id])
    if @section.update(section_params)
      flash_message("Section Information Updated")
      redirect_to( admin_sections_path )
    else
      @page_title = "Edit Section"
      @page_description = @section.name
      render(:action => :edit)
    end
  end

  def download_stats
    @section = Section.find(params[:id])
    send_data @section.to_csv, :filename => @section.name.parameterize + '.csv'
  end

  def update_leadership
    @section = Section.find(params[:id])
    @section.assign_primary_group_leader( params[:primary_leader] )

    flash_message("Section Leadership Updated")
    redirect_to( admin_section_path( @section ) )
  end

  def add_members
    @section = Section.find(params[:id])
    params[:chamber_role_ids].each do |chamber_role_id|
      @section.add_member( chamber_role_id )
    end

    flash_message("Section Members Added")
    redirect_to( admin_section_path( @section ) )
  end

  def remove_members
    @section = Section.find(params[:id])
    params[:chamber_role_ids].each do |chamber_role_id|
      @section.remove_member( chamber_role_id )
    end

    flash_message("Section Members Removed")
    redirect_to( admin_section_path( @section ) )
  end

  private 
  
  def section_params
    params.require(:section).permit!
  end
end
