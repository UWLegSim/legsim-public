class BallotsController < ApplicationController

  def update
    ballot = Ballot.find( params[:id] )
    ballot.update!( ballot_params )
    ballot.vote.recount

    respond_to do |format|
      format.json { render :json => ballot.to_json }
    end
  end

  private

  def ballot_params
    params.require(:ballot).permit!
  end  

end
