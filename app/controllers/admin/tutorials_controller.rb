class Admin::TutorialsController < ApplicationController

  def index
    @tutorials = @current_chamber.tutorials
    @page_title = "Tutorial Management"
  end

  def new
    @tutorial = @current_chamber.tutorials.new
  end

  def edit
    @tutorial = Tutorial.find( params[:id] )
  end

  def create
    @tutorial = Tutorial.new( tutorial_params )
    if @tutorial.save
      display_message("Tutorial Created")
      redirect_to( admin_tutorials_path )
    else
      render(:action => :new)
    end
  end

  def update
    @tutorial = Tutorial.find( params[:id] )
    if @tutorial.update(tutorial_params)
      display_message("Tutorial Updated")
      redirect_to( edit_admin_tutorial_path( @tutorial ) )
    else
      render(:action => :edit)
    end
  end

  def destroy
    tutorial = Tutorial.destroy( params[:id] )
    flash_message("Tutorial <b>#{tutorial.title}</b> deleted.")
    redirect_to( admin_tutorials_path )
  end

  def reorder
    current_chamber.tutorials.each do |tutorial|
      tutorial.update(
        :position => params["tutorial_#{tutorial.id}"]
      )
    end
    flash_message("Tutorial positions updated")
    redirect_to( admin_tutorials_path )
  end

  def tutorial_params
    params.require(:tutorial).permit!
  end
end
