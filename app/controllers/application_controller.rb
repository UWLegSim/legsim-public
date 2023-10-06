# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery with: :exception, prepend: false # :secret => '812b8ca18234cac8055df81db351d018'

#  include AuthenticatedSystem

  before_action :authenticate_user!
  before_action :init_session
  before_action :set_raven_context

#   before_action :login_required
#   before_action :init_session
  before_action :track_action

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  # filter_parameter_logging :password

  def check_confirmation!
    puts "#check_confirmation!"
    # puts current_user.id
    # puts current_user.confirmed?
    unless current_user.confirmed?
      render 'sessions/unauthorized'
    end
  end

  private

  def set_raven_context
    Raven.user_context(id: session[:current_user_id]) # or anything else in session
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def current_chamber
    current_user&.last_chamber
  end

  def current_chamber_role
    current_user.chamber_role( current_chamber ) || current_user.chamber_roles.last
  end

  def previous_user
    @previous_user = User.find_by_id(session[:previous_user_id]) if session[:previous_user_id]
  end

  def previous_user=(old_user)
    session[:previous_user_id] = old_user ? old_user.id : nil
    @previous_user = old_user || false
  end

  def authorize( options )

    options[:chamber_role] = @current_chamber_role unless options[:chamber_role]

    if options[:chamber_role].is_administrator?
      true
    elsif options[:group] && options[:group].authorized?( :chamber_role => options[:chamber_role] )
      true
    elsif options[:member_of] && options[:member_of].is_member?( options[:chamber_role] )
      true
    elsif options[:is_role] && options[:chamber_role].is_a?( options[:is_role] )
      true
    else
      render 'sessions/unauthorized'
    end
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

  def init_session
    @current_user = current_user
    @current_chamber = current_chamber
    @current_chamber_role = current_chamber_role if @current_chamber && @current_user
    @previous_user = previous_user

    Time.zone = current_user.course.time_zone if current_user&.course
  end

  def track_action
    if @current_user
      if request.get? or request.head?
        @current_user.actions.create!( :request_type => 'get' )
      else
        @current_user.actions.create!( :request_type => 'post' )
      end
    end
  end
end
