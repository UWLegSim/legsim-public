class SystemController < ActionController::Base

#  skip_before_action :authenticate_user!

  before_action :authenticate_system_user!

#  include SystemAuthenticatedSystem

#   skip_before_action :login_required
#   skip_before_action :init_session
#   skip_before_action :track_action

  def index
#     render :layout => 'system'
  end

  def init_session
  end

  def track_action
  end

  def display_message( msg, type = :notice )
    if flash[type].nil?
      flash[type] = [msg]
    else
      flash[type] << msg
    end
  end

  def flash_message( msg, type = :notice )
    if flash[type].nil?
      flash[type] = [msg]
    else
      flash[type] << msg
    end
  end

end
