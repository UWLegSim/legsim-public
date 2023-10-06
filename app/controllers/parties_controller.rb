class PartiesController < ApplicationController

  def manage
    @party = Party.find( params[:id] )
    @page_title = "Party Management"
    @page_description = @party.name
  end

  def manage_discussions
    @party = Party.find( params[:id] )
    @page_title = "Party Discussion Management"
    @page_description = @party.name
  end

  def manage_referrals
    @party = Party.find( params[:id] )
    @referral = @party.referrals.new(
      :priority => 'secondary'
    )
    @page_title = "Party Legislative Study Management"
    @page_description = @party.name
  end

  def manage_info
    @party = Party.find( params[:id] )
    @page_title = "Party Information Management"
    @page_description = @party.name
  end

  def manage_votes
    @party = Party.find( params[:id] )
    @page_title = "Party Vote Management"
    @page_description = @party.name
  end

  def leave
    @party = Party.find( params[:id] )
    @party.remove_member( @current_chamber_role.id )

    flash_message("You have left the #{@party.name}",:attention)
    redirect_to( @party )
  end

  def join
    @party = Party.find( params[:id] )
    old_party = @current_chamber_role.party

    @party.add_member( @current_chamber_role.id )

    if old_party
      old_party.remove_member( @current_chamber_role.id )
      flash_message("You have left the #{old_party.name} and joined the #{@party.name}",:attention)
    else
      flash_message("You have joined the #{@party.name}",:attention)
    end

    redirect_to( @party )
  end

  def index
    @parties = @current_chamber.parties
    @page_title = 'Party Directory'
  end

  def show
    @party = Party.find( params[:id] )
    @page_title = @party.name
  end

  def new
    @page_title = "New Party"
    @page_description = "Create a member driven organization based around a broad ideology"
    @party = current_chamber.parties.new
  end

  def create
    @party = Party.new( party_params )
      if @party.save
        @party.add_member( @current_chamber_role.id )
        @party.group_leaders.create!(
        :chamber_role_id => @current_chamber_role.id,
        :title => 'Party Leader',
        :primary => true
        )
        flash_message("#{@party.name} has been created")
        redirect_to( @party )
      else
        render(:action => :new)
    end
  end

  def edit
    @party = Party.find( params[:id] )
  end

  def update
    @party = Party.find(params[:id])
    @party.update(party_params) ?
      redirect_to( @party ) : render(:action => :edit)
  end


  def destroy
    Party.destroy( params[:id] )
    redirect_to( parties_path )
  end

  def party_params
    params.require(:party).permit!
  end
end
