class CalendarsController < ApplicationController

  def add_items
    calendar = Calendar.find(params[:calendar_id])

    params[:referral_ids].each do |referral_id|

      referral = Referral.find( referral_id  )
      calendar.add_item( referral, @current_chamber_role )

    end

    flash_message("Legislation added to the #{calendar.name}")
    redirect_to( manage_calendars_floor_path( calendar.group) )

  end

  def holds
    @calendars = @current_chamber.floor.calendars
    @holdable_referrals = @calendars.collect do |calendar|
      calendar.referrals.includes( :legislation )
    end.flatten

    @page_title = "Legislative Holds"
    @page_description = @current_chamber.floor.name
  end

  def place_hold

    hold = Hold.find_or_create_by(
      referral_id: params[:referral_id], 
      chamber_role_id: @current_chamber_role.id
    )

    flash_message("Hold placed on #{hold.legislation.title}")
    redirect_to( holds_calendars_path )

  end

  def remove_hold

    hold = Hold.find( params[:hold_id] )
    hold.destroy

    flash_message("Hold removed from #{hold.legislation.title}")
    redirect_to( holds_calendars_path )

  end

  def index
    @calendars = @current_chamber.floor.calendars
    @page_title = "Calendars"
    @page_description = @current_chamber.floor.name
  end

  def create
    calendar = Calendar.create!( calendar_params )

    flash_message("New Calendar created for #{calendar.group.name}")
    redirect_to( manage_calendars_floor_path( calendar.group) )
  end

  def update
    @calendar = Calendar.find(params[:id])
    if @calendar.update(calendar_params)
      flash_message("Calendar Updated")
      redirect_to( manage_calendars_floor_path(@calendar.group) )
    else
      @page_title = "Edit Calendar"
      @page_description = @calendar.name
      render(:action => :edit)
    end
  end


  def new
    group = Group.find( params[:group_id] )
    @calendar = group.calendars.new

    @page_title = "New Calendar"
    @page_description = group.name
  end

  def edit
    @calendar = Calendar.find( params[:id] )
    @page_title = "Edit Calendar"
    @page_description = @calendar.name
  end

  private

  def calendar_params
    params.require(:calendar).permit!
  end  

end
