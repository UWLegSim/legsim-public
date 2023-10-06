class CaucusesController < ApplicationController

  def manage
    @caucus = Caucus.find( params[:id] )
    @page_title = "Caucus Management"
    @page_description = @caucus.name
  end

  def manage_discussions
    @caucus = Caucus.find( params[:id] )
    @page_title = "Caucus Discussion Management"
    @page_description = @caucus.name
  end

  def manage_referrals
    @caucus = Caucus.find( params[:id] )
    @referral = @caucus.referrals.new(
      :priority => 'secondary'
    )
    @page_title = "Caucus Legislative Study Management"
    @page_description = @caucus.name
  end

  def manage_info
    @caucus = Caucus.find( params[:id] )
    @page_title = "Caucus Information Management"
    @page_description = @caucus.name
  end

  def manage_votes
    @caucus = Caucus.find( params[:id] )
    @page_title = "Caucus Vote Management"
    @page_description = @caucus.name
  end

  def leave
    @caucus = Caucus.find( params[:id] )
    @caucus.remove_member( @current_chamber_role.id )

    flash_message("You have left the #{@caucus.name}",:attention)
    redirect_to( @caucus )
  end

  def join
    @caucus = Caucus.find( params[:id] )
    @caucus.add_member( @current_chamber_role.id )

    flash_message("You have joined the #{@caucus.name}",:attention)
    redirect_to( @caucus )
  end

  def index
    @caucuses = current_chamber.caucuses
    @page_title = 'Caucus Directory'
  end

  def show
    @caucus = Caucus.find( params[:id] )
    @page_title = @caucus.name
  end

  def new
    @page_title = "New Caucus"
    @page_description = "Create a member driven organization based around a specific issue area"
    @caucus = current_chamber.caucuses.new
  end

  def create
    @caucus = Caucus.new( caucus_params )
    if @caucus.save
      @caucus.add_member( @current_chamber_role.id )
      @caucus.group_leaders.create!(
        :chamber_role_id => @current_chamber_role.id,
        :title => 'Caucus Leader',
        :primary => true
      )
      flash_message("#{@caucus.name} has been created")
      redirect_to( @caucus )
    else
      render(:action => :new)
    end
  end

  def edit
    @caucus = Caucus.find( params[:id] )
  end

  def update
    @caucus = Caucus.find(params[:id])
    if @caucus.update(caucus_params)
      flash_message("Caucus Information Updated")
      redirect_to( manage_info_caucus_path(@caucus) )
    else
      @page_title = "Caucus Information Management"
      @page_description = @caucus.name
      render(:action => :manage_info)
    end
  end

  def destroy
    Caucus.destroy( params[:id] )
    redirect_to( caucuses_path )
  end

  private
  
  def caucus_params
    params.require(:caucus).permit(:name,:abbr,:jurisdiction_description,:issue_description,:chamber_id,:public_announcement, :private_announcement)
  end

end
