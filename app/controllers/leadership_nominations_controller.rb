class LeadershipNominationsController < ApplicationController
  
  # GET /leadership_nominations
  # GET /leadership_nominations.xml
  def index
    @leadership_nominations = LeadershipNomination.all
    @leadership_nomination= LeadershipNomination.new
    @chamber_nominations = Array.new

    @page_title = "Chamber Leadership"


    # This is the filter for the current legislative chamber
    # So if you had two different chambers, a house and a senate
    # This where the nominations are filtered for a chamber, i.e. 
    # Only the nominations for the house of representatives leadership
    # Nominations appears in the house leadership nominations page
    @leadership_nominations.each do |f|
      if f.chamber_id == current_chamber.id
        @chamber_nominations.push f
      end
    end 

    if @chamber_nominations.length == nil
      @temp_nom = LeadershipNomination.new
      @chamber_nominations<< @temp_nom
    end
  end

  def find_executive
    # This is currently for the unitary situation of chamber executivism
    @excutives = Chamber_Role.find( params[:type])
    return @executives.id
  end

  # GET /leadership_nominations/1
  # GET /leadership_nominations/1.xml
  def show
    redirect_to(leadership_nominations_path)
  end

  # GET /leadership_nominations/new
  # GET /leadership_nominations/new.xml
  def new

  end

  # GET /leadership_nominations/1/edit
  def edit
    @leadership_nomination = LeadershipNomination.find(params[:id])
  end

  # POST /leadership_nominations
  # POST /leadership_nominations.xml
  def create
    @leadership_nomination = LeadershipNomination.new( leadership_nomination_params )
    @leadership_nominations = LeadershipNomination.all

    @leadership_nomination.chamber_id = @current_chamber.id
    @leadership_nominations.each do |f|
      if@leadership_nomination.chamber_role == f.chamber_role
        f.endorsements+=1
        f.save
        flash_message('Leadership Nomination Successful')
        redirect_to(leadership_nominations_path) and return
      end
    end
    @leadership_nomination.endorsements = 1
    @leadership_nomination.save
    flash_message('Leadership Nomination Successful')
    redirect_to(leadership_nominations_path)
  end

  # PUT /leadership_nominations/1
  # PUT /leadership_nominations/1.xml
  def update
  end

  # DELETE /leadership_nominations/1
  # DELETE /leadership_nominations/1.xml
  def destroy
    @leadership_nomination = LeadershipNomination.find(params[:id])
    @leadership_nomination.destroy

    respond_to do |format|
      format.html { redirect_to(leadership_nominations_url) }
      format.xml  { head :ok }
    end
  end

  def leadership_nomination_params
    params.require(:leadership_nomination).permit!
  end
end