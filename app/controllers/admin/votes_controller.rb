class Admin::VotesController < ApplicationController

  def index
    @votes = current_chamber.votes.includes( motion: { referral: [ :group, :legislation ] } )
    @floor = current_chamber.floor
  end

end
