class SectionsController < ApplicationController

  def manage
    @section = Section.find( params[:id] )
    @page_title = "Section Management"
    @page_description = @section.name
  end

  def manage_discussions
    @section = Section.find( params[:id] )
    @page_title = "Section Discussion Management"
    @page_description = @section.name
  end

  def manage_referrals
    @section = Section.find( params[:id] )
    @page_title = "Section Referral Management"
    @page_description = @section.name
  end

  def manage_info
    @section = Section.find( params[:id] )
    @page_title = "Section Information Management"
    @page_description = @section.name
  end

  def index
    @sections = current_chamber.sections
    @page_title = 'Section Directory'
  end

  def show
    @section = Section.find( params[:id] )
    @page_title = @section.name
  end

  def new
    @section = current_chamber.sections.new
  end

  def create
    @section = Section.new( section_params )
    @section.save ? redirect_to( @section ) : render(:action => :new)
  end

  def edit
    @section = Section.find( params[:id] )
  end

  def update
    @section = Section.find(params[:id])
    if @section.update(section_params)
      flash_message("Section Information Updated")
      redirect_to( manage_info_section_path(@section) )
    else
      @page_title = "Section Information Management"
      @page_description = @section.name
      render(:action => :manage_info)
    end
  end

  def destroy
    Section.destroy( params[:id] )
    redirect_to( sections_path )
  end

  def section_params
    params.require(:section).permit!
  end
end
