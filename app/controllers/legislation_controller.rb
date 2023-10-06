class LegislationController < ApplicationController

  def add_cosponsor
    @legislation = Legislation.find( params[:id] )
    @legislation.add_cosponsor( @current_chamber_role )
    flash_message("You have become a cosponsor of #{@legislation.reference}")
    redirect_to( legislation_path(@legislation) )
  end

  def remove_cosponsor
    @legislation = Legislation.find( params[:id] )
    @legislation.remove_cosponsor( @current_chamber_role )
    flash_message("You have withdrawn cosponsorship from #{@legislation.reference}")
    redirect_to( legislation_path(@legislation) )
  end

  def search

    @page_title = @current_chamber.name
    @page_description = "Search Legislation"

    @query = {
      :chamber_id           => @current_chamber.id,
      :legislative_type_ids => params[:legislative_type_ids] || [],
      :status               => params[:status] || []
    }

    @legislation = Legislation.search( @query )

  end

  def index
    @legislation = @current_chamber.legislation.active

    @page_title = @current_chamber.name
    @page_description = "Browse Legislation"

  end

  def show
    @legislation = Legislation.find( params[:id] )
    @page_title = @legislation.reference
    @page_description = @legislation.name
  end

  def new
    @page_title = "Submit Legislation"
    @page_description = "Propose legislation for consideration by the chamber"

    @chamber = current_chamber
    @legislation = Legislation.new
    @legislation.submission_text = LegislativeText.new
  end

  def create
    @legislation = Legislation.new( legislation_params )
    @legislation.sponsor = @current_chamber_role
    if @legislation.save
      flash_message("Your legislation has been introduced as #{@legislation.reference}")
      redirect_to( legislation_path(@legislation) )
    else
      flash_message("You are missing some required information")
      @chamber = current_chamber
      render(:action => :new)
    end
  end

  def edit
    @chamber = current_chamber
    @legislation = Legislation.find( params[:id] )

    @page_title = @legislation.reference
    @page_description = "Revise Legislation"

  end

  def update
    @legislation = Legislation.find(params[:id])
    if @legislation.update(legislation_params)
      flash_message("#{@legislation.reference} has been updated")
      redirect_to( legislation_path(@legislation) )
    else
      render(:action => :edit)
    end
  end

  def destroy
    Legislation.destroy( params[:id] )
    redirect_to( legislation_path )
  end

  private

  def legislation_params
    params.require(:legislation).permit!
  end


end