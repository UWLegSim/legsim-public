class ReportsController < ApplicationController

  def show
    @report = Report.find( params[:id] )

    @page_title = @report.legislation.reference
    @page_description = "#{@report.group.name} Report"
  end

  def edit
    @report = Report.find( params[:id] )
    @page_title = @report.legislation.reference
    @page_description = "Draft #{@report.group.name} Report"
  end

  def new
    referral = Referral.find( params[:referral_id] )
    @report = Report.new( :referral => referral, :status => 'draft' )

    @report.reported_text = LegislativeText.new(
      :primary_text   => referral.referred_text.primary_text,
      :secondary_text => "<h2>Purpose and Summary of the Legislation</h2><p></p><h2>Background and Need for the Legislation</h2><p></p><h2>Summary of Committee Consideration and Voting</h2><p></p><h2>Minority Views</h2><p></p><h2>Report Author(s)</h2><p></p>"
    )

    @page_title = referral.legislation.reference
    @page_description = "Draft #{referral.group.name} Report"
  end

  def publish

    report = Report.find( params[:id] )
    report.publish

    if report.group.is_committee?
      flash_message("Committee Report has been published")
      flash_message("#{report.referral.discussion.name} has been closed")
      redirect_to manage_referrals_committee_path(report.group)
    elsif report.group.is_caucus?
      flash_message("Legislative Study Report has been published")
      flash_message("#{report.referral.discussion.name} has been closed")
      redirect_to manage_referrals_caucus_path(report.group)
    elsif report.group.is_party?
      flash_message("Legislative Study Report has been published")
      flash_message("#{report.referral.discussion.name} has been closed")
      redirect_to manage_referrals_party_path(report.group)
    end

  end

  def update
    report = Report.find( params[:id] )
    report.update!( report_params )

    if report.group.is_committee?
      flash_message("Draft Committee Report has been revised")
      redirect_to manage_referrals_committee_path(report.group)
    elsif report.group.is_caucus?
      flash_message("Draft Legislative Study Report has been revised")
      redirect_to manage_referrals_caucus_path(report.group)
    elsif report.group.is_party?
      flash_message("Draft Legislative Study Report has been revised")
      redirect_to manage_referrals_party_path(report.group)
    end

  end

  def create
    report = Report.create!( report_params )

    if report.group.is_committee?
      flash_message("Draft Committee Report has been submitted")
      redirect_to manage_referrals_committee_path(report.group)
    elsif report.group.is_caucus?
      flash_message("Draft Legislative Study Report has been submitted")
      redirect_to manage_referrals_caucus_path(report.group)
    elsif report.group.is_party?
      flash_message("Draft Legislative Study Report has been submitted")
      redirect_to manage_referrals_party_path(report.group)
    end

  end

  def report_params
    params.require(:report).permit!
  end
end
