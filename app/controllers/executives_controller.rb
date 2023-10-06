class ExecutivesController < ApplicationController

  def index
    if current_chamber.setting('has_executive') == 'Unitary'
      executive = current_chamber.executives[0]
      if executive
        redirect_to( executive_path )
      else
        display_message("There is no executive for this chamber.")
        redirect_to (home_path)
      end
    elsif current_chamber.settings('has_executive') == 'Multiple'
      @executives = current_chamber.executives
    end
  end

  def show
    @executive = Executive.find( params[:id] )
    @page_title = current_chamber.setting('executive_title')
    @page_description = @executive.name
  end

  def edit
    @executive = Executive.find( params[:id] )
    @executive.executive_profile = ExecutiveProfile.new( :executive => @executive ) unless @executive.executive_profile
    if @current_chamber_role
      render
    else
      @current_chamber = @executive.chamber
      render :layout => 'public'
    end
  end

  def create
    @legislation = Legislation.find(params[:id])
    if params[:commit] == 'sign'
      @legislation.status = 'law'
    elsif params[:commit]== 'veto'
      @legislation.status = 'vetoed'
    end

    @legislation.save
    redirect_to(home_path)
  end

  def veto
    @legislation = Legislation.find(params[:id])
    @legislation.status = 'vetoed'
    @legislation.save
    redirect_to(@current_chamber.floor)
  end

  def update
    @executive = Executive.find(params[:id])
    if @executive.update(executive_params)
      
      @executive.photo.purge if params[:delete_photo]

      display_message("Profile Updated")
      redirect_to( @executive.user )
    else
      display_message("Profile Update Failed",:error)
      render(:action => :edit)
    end
  end

  def executive_params
    params.require(:executive).permit!
  end
end
