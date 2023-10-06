class AmendmentsController < ApplicationController

  def show
    @amendment = Amendment.find( params[:id] )
    @page_title = @amendment.legislation.title
    @page_description = "#{@amendment.group.name} Amendment #{@amendment.number}"
  end

  def new
    referral = Referral.find( params[:referral_id] )
    @amendment = referral.amendments.new
    @page_title = "Propose Amendment"
    @page_description = @amendment.referral.group.name
  end

  def create

    @amendment = Amendment.new( amendment_params )
    @amendment.sponsor = @current_chamber_role
    if @amendment.save
      flash_message("Your amendment has been introduced")
      redirect_to( amendment_path(@amendment) )
    else
      @page_title = "Propose Amendment"
      @page_description = @amendment.referral.group.name
      render(:action => :new)
    end

  end

  private

  def amendment_params
    params.require(:amendment).permit!
  end

end
