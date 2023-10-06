# This controller handles the login/logout function of the site.
class LegacySessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  # include AuthenticatedSystem

#  skip_before_action :login_required
#  skip_before_action :init_session
#  skip_before_action :track_action

  # render new.rhtml
  def new
    @page_title = "Welcome to LegSim"
    @courses = Course.accessible.includes( :institution ).order( 'institutions.name' )
    render :layout => 'public'
  end

  # def create
  #   logout_keeping_session!
  #   user = User.authenticate(params[:login], params[:password], params[:course_id])
  #   if user
  #     # Protects against session fixation attacks, causes request forgery
  #     # protection if user resubmits an earlier form using back
  #     # button. Uncomment if you understand the tradeoffs.
  #     # reset_session
  #     self.current_user = user
  #     new_cookie_flag = (params[:remember_me] == "1")
  #     handle_remember_cookie! new_cookie_flag


  #     if user.last_chamber

  #       cookies['previous_chamber_id'] = {
  #         :value => user.last_chamber.id,
  #         :expires => 1.year.from_now,
  #       }

  #       redirect_back_or_default('/home')
  #       display_message("Logged in successfully")

  #     else

  #       chamber_role = user.chamber_roles.first
  #       user.last_chamber = chamber_role.chamber
  #       user.save

  #       cookies['previous_chamber_id'] = {
  #         :value => chamber_role.chamber_id,
  #         :expires => 1.year.from_now,
  #       }

  #       if chamber_role.is_member?
  #         redirect_to edit_member_path( chamber_role )
  #       elsif chamber_role.is_administrator?
  #         redirect_to edit_administrator_path( chamber_role )
  #       elsif chamber_role.is_executive?
  #         redirect_to edit_executive_path( chamber_role )
  #       elsif chamber_role.is_instructor?
  #         redirect_to edit_instructor_path( chamber_role )
  #       end

  #     end
  #   else
  #     note_failed_signin
  #     @courses = Course.all
  #     @login       = params[:login]
  #     @remember_me = params[:remember_me]
  #     render :action => 'new', :layout => 'public'
  #   end
  # end

  def destroy
    logout_killing_session!
    display_message("You have been logged out.")
    redirect_back_or_default('/')
  end

  def assume
    self.previous_user = current_user

    @chamber_role = ChamberRole.find( params[:chamber_role_id] )
    user = @chamber_role.user
    user.last_chamber = @chamber_role.chamber
    user.save

    self.current_user = user

    redirect_to('/home')
    display_message("#{@chamber_role.system_name} account assumed succesfully", :attention)

  end

  def release
    if previous_user

      self.current_user = previous_user
      self.previous_user = nil
      redirect_to('/home')
      display_message("Assumed account released succesfully", :attention)

    end
  end

protected
  # Track failed login attempts
  def note_failed_signin
    display_message("Couldn't log you in as '#{params[:login]}' (username, not email address?)",:error)
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
