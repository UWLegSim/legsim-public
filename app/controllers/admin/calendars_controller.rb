class Admin::CalendarsController < ApplicationController

  def index
    @calendars = current_chamber.floor.calendars
  end

  def update_positions
    calendar = Calendar.find( params[:id] )

    calendar.calendar_referrals.each do |calendar_referral|
#       puts calendar_referral.id.inspect
#       puts params[:calendar_referral][calendar_referral.id.to_s].inspect
      calendar_referral.update( :position => params[:calendar_referral][calendar_referral.id.to_s][:position] )
    end

    redirect_to( [:admin,:calendars], :notice => "Calendar Positions Updated!" )

  end
end
