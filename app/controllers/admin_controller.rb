class AdminController < ApplicationController

  before_action :verify_administrator

  def index
#     render :layout => 'system'
  end

  def verify_administrator
    authorize( :is_role => Administrator )
  end

end
