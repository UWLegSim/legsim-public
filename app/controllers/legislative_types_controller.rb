class LegislativeTypesController < ApplicationController

  def new
    @legislative_type = Chamber.find( params[:chamber_id] ).legislative_types.new
  end

  def create
    @legislative_type = LegislativeType.new( legislative_type_params )
    @legislative_type.save ? redirect_to( @legislative_type.chamber ) : render(:action => :new)
  end

  def edit
    @legislative_type = LegislativeType.find( params[:id] )
  end

  def update
    @legislative_type = LegislativeType.find(params[:id])
    @legislative_type.update(legislative_type_params) ?
      redirect_to( @legislative_type.chamber ) : render(:action => :edit)
  end


  def destroy
    @legislative_type = LegislativeType.find(params[:id])
    @legislative_type.destroy
    redirect_to( @legislative_type.chamber )
  end

  def legislative_type_params
    params.require(:legislative_type).permit!
  end
end
