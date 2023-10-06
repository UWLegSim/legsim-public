class System::SystemUsersController < SystemController

  # Protect these actions behind an admin login
  # before_action :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_action :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]
  # skip_before_action :login_required, :only => [:activate, :remember_password, :request_password_reset, :reset_password]
  # skip_before_action :init_session,   :only => [:activate, :remember_password, :request_password_reset, :reset_password]
  # skip_before_action :track_action,   :only => [:new, :create, :activate, :remember_password, :request_password_reset, :reset_password]

  # render new.rhtml
  def new
    @system_user = SystemUser.new
  end

  def create
    @system_user = SystemUser.new( system_user_params )

    if @system_user.save
      display_message("A new System User has been create and an activation email sent to the specified email address.")
      redirect_to :action => 'index'
    else
      display_message("We couldn't set up that account, sorry.  Please try again, or contact an admininistrator.",:error)
      render :action => 'new'
    end
  end

  def index
    @system_users = SystemUser.all
  end

  def system_user_params
    params.require(:system_user).permit!
  end
end
