class GroupsController < ApplicationController

  def csv
    @group = Group.find( params[:id] )
    send_data @group.to_csv, :filename => "#{@group.name.parameterize}.csv"
#     render plain: @group.to_csv
  end

end
