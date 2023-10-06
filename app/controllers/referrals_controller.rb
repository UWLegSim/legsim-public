class ReferralsController < ApplicationController

  def show
    @referral = Referral.find( params[:id] )
    @page_title = @referral.group.name
    @page_description = @referral.legislation.title
  end

  def create
    referral = Referral.new( referral_params )
    referral.update(
      :referrer      => @current_chamber_role,
      :status        => 'hearing',
      :referred_text => referral.legislation.submission_text
    )

    referral.save
    referral.manage_discussion( :chamber_role => @current_chamber_role )

    if referral.group.is_caucus?
      flash_message("Legislative Study has been started.")
      redirect_to manage_referrals_caucus_path(referral.group)
    elsif referral.group.is_party?
      flash_message("Legislative Study has been started.")
      redirect_to manage_referrals_party_path(referral.group)
    end

  end

  def update
    referral = Referral.find( params[:id] )
    referral.update( referral_params )
    referral.manage_discussion( :chamber_role => @current_chamber_role )

    flash_message("Referral has been updated.")
    if referral.group.is_committee?
      redirect_to manage_referrals_committee_path(referral.group)
    elsif referral.group.is_floor?
      redirect_to manage_referrals_floor_path(referral.group)
    elsif referral.group.is_caucus?
      redirect_to manage_referrals_caucus_path(referral.group)
    elsif referral.group.is_party?
      redirect_to manage_referrals_party_path(referral.group)
    end
  end

  def referral_params
    params.require(:referral).permit!
  end
end
