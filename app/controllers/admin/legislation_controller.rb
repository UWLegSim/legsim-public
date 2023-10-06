class Admin::LegislationController < ApplicationController

  def index
    @chamber = current_chamber
  end

end
