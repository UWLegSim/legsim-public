class Admin::FloorsController < ApplicationController

  def download_stats
    @floor = Floor.find(params[:id])
    send_data @floor.to_csv, :filename => @floor.name.parameterize + '.csv'
  end

end
