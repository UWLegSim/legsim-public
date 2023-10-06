class AdministratorsController < ApplicationController

  def edit
    @administrator = Administrator.find( params[:id] )
    if @current_chamber_role
      render
    else
      @current_chamber = @administrator.chamber
      render :layout => 'public'
    end
  end

  def update
    @administrator = Administrator.find(params[:id])
    if @administrator.update(administrator_params)
      
      @administrator.photo.purge if params[:delete_photo]

      display_message("Profile Updated")
      redirect_to( @administrator.user )
    else
      display_message("Profile Update Failed",:error)
      render(:action => :edit)
    end
  end

  private

  def administrator_params
    params.require(:administrator).permit!
  end

end
