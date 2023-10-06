class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  # include AuthenticatedSystem

  # Protect these actions behind an admin login
  # before_action :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_action :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]
#   skip_before_action :login_required, :only => [:new, :create, :activate, :remember_password, :request_password_reset, :reset_password, :confirm_payment]
#  skip_before_action :init_session,   :only => [:new, :create, :activate, :remember_password, :request_password_reset, :reset_password, :confirm_payment]
#  skip_before_action :track_action,   :only => [:new, :create, :activate, :remember_password, :request_password_reset, :reset_password, :confirm_payment]

  def show
    unless @current_chamber
      @current_chamber_role = current_user.chamber_roles.first
      @current_chamber = @current_chamber_role.chamber

      current_user.last_chamber = @current_chamber
      current_user.save
    end

    if @current_chamber_role.is_member?
      @member = @current_chamber_role

      @page_title = "Member Desk"
      @page_description = "From here you can access all the tools necessary to represent your constituency"
      render 'members/home'
    elsif @current_chamber_role.is_administrator?
      @administrator = @current_chamber_role

      @page_title = "Administrator Desk"
      @page_description = "From here you can administer any aspect of the course or chamber"
      render 'administrators/home'
    elsif @current_chamber_role.is_executive?
      @executive = @current_chamber_role

      @page_title = "Executive Desk"
      @page_description = "From here you can exercise your executive powers"
      render 'executives/home'
    elsif @current_chamber_role.is_instructor?
      @instructor = @current_chamber_role

      @page_title = "Instructor Desk"
      @page_description = "From here you can manage your assigned sections"
      render 'instructors/home'
    end

  end

  # render new.rhtml
  def new
    @user = User.new
    @authorization_code = AuthorizationCode.new
    render :layout => 'public'
  end

  def foliodirect
  end

  def create
    logout_keeping_session!
    @authorization_code = AuthorizationCode.find_by_code( params[:authorization_code] )
    @agreement = (params[:user][:agreement] == '1') ? true : false

    if @authorization_code && @agreement
      @user = @authorization_code.chamber.course.users.new( user_params )
      if @user && @user.valid?
        chamber_role = @authorization_code.create_chamber_role( @user )
        @user.register!
      end

      success = chamber_role && chamber_role.valid? && @user && @user.valid?
    else
      @user = User.new( user_params )
      success = false
    end

    if success && @user.errors.empty? && chamber_role.errors.empty?
#       @user.activate!
      if chamber_role.is_member?
        if @user.course.payment_foliodirect?
          render :action => 'foliodirect', :layout => 'public'
        elsif @user.course.payment_uw_cforc?
          render :action => 'uw_cforc', :layout => 'public'
        elsif @user.course.payment_prepaid?
          display_message("Thanks for signing up!  We're sending you an email with your activation code.")
          redirect_back_or_default('/')
        end
      else
        display_message("Thanks for signing up!  We're sending you an email with your activation code.")
        redirect_back_or_default('/')
      end
#       display_message("Thanks for signing up! You can now login with your credentials.")
    else
      if @authorization_code
        if @agreement
          display_message("We couldn't set up that account, sorry.  Please try again, or contact an admininistrator.",:error)
        else
          display_message("You must agree to the LegSim User Agreement before we can create your account.",:error)
        end
      else
        display_message("The provided authorization code is not valid. Please check the code provided by your insructor and try again.",:error)
      end
      render :action => 'new', :layout => 'public'
    end
  end

  def confirm_payment
    user = User.find_by_payment_token( params[:hash] )
    user.payment_token = nil
    user.payment_ref = params[:pnref]
    user.save

    user.send_activation_code

    render plain: "OK"
  end

  def activate
    logout_keeping_session!
    activation_code = params[:activation_code] || params[:id]
    user = User.find_by_activation_code(activation_code) unless activation_code.blank?
    case
    when (!activation_code.blank?) && user && !user.active?
      user.activate!
      display_message("Signup complete! Please Select Your Session and sign in to continue.")
      redirect_to '/login'
    when activation_code.blank?
      display_message("The activation code was missing.  Please follow the URL from your email.",:error)
      redirect_back_or_default('/')
    else
      display_message("We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in.",:error)
      redirect_back_or_default('/')
    end
  end

  def edit_password
    @user = current_user
  end

  def update_password

    @user = current_user
    @user.password = user_params[:password] if user_params[:password] == user_params[:password_confirmation]

    if @user.valid?
      @user.save
      sign_in( @user, bypass: true )
      flash_message("Your password has been changed")
      redirect_to '/home'
    else
      @user.errors.each do |error|
        flash_message(error,:error)
      end
      render 'edit_password'
    end
  end

  def reset_password

    @user = User.find_by_password_reset_code(params[:password_reset_code]) unless params[:password_reset_code].blank?
    if @user
      @new_password = @user.generate_random_password
      @user.update!(
        :password              => @new_password,
        :password_confirmation => @new_password,
        :password_reset_code   => nil
      )
    end

    render :layout => 'public'

  end

  def remember_password
    @page_title = "Password Reset"
    @page_description = ""
    @courses = Course.all
    render :layout => 'public'
  end

  def request_password_reset
    @page_title = "Password Reset Request"

    if course = Course.find(params[:course_id])
      if user = course.users.find_by_login(params[:login])
        user.send_password_reset_code
        @message = "A password reset link has been sent to the email address on record for #{user.login}."
      else
        @message = "The username (not email) you specified does not exist for the selected course."
      end

    else
      @message = "You have not provided a course."
    end

    render :layout => 'public'

  end

  def suspend
    @user.suspend!
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend!
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end

  # There's no page here to update or destroy a user.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.
  def user_params
    params.require(:user).permit!
  end

protected
  def find_user
    @user = User.find(params[:id])
  end
end
