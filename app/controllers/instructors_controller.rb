class InstructorsController < ApplicationController

  def edit
    @instructor = Instructor.find( params[:id] )
    if @current_chamber_role
      render
    else
      @current_chamber = @instructor.chamber
      render :layout => 'public'
    end
  end

  def update
    @instructor = Instructor.find( params[:id] )
    if @instructor.update( instructor_params )
      @instructor.photo.purge if params[:delete_photo]

      display_message("Profile Updated")
      redirect_to( @instructor.user )
    else
      display_message("Profile Update Failed",:error)
      render(:action => :edit)
    end
  end

  def instructor_params
    params.require(:instructor).permit!
  end
end
