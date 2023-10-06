# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  prepend_before_action :require_no_authentication, only: [:clear]

  # GET /resource/sign_in
  def new
    @page_title = true
    @courses = Course.accessible.includes(:institution).order('institutions.name')
    super
  end

  def clear
    reset_session
    redirect_to('/')
  end

  def assume
    
    chamber_role = ChamberRole.find( params[:chamber_role_id] )
    user = chamber_role.user

    if current_chamber_role.is_administrator? && chamber_role.chamber == current_chamber

      session[:previous_user_id] = current_user.id
      user.update( last_chamber: chamber_role.chamber )
      sign_in( user )

      redirect_to('/home')
      display_message("#{chamber_role.system_name} account assumed succesfully", :attention)
    else
      redirect_to('/home', notice: "You are not authorized to assume this user, so the assume action was aborted.")
    end

  end

  def release

    user = User.find(session[:previous_user_id])

    if user && user.last_chamber == current_chamber
      
      sign_in(user)
      session[:previous_user_id] = nil

      redirect_to('/home')
      display_message("Assumed account released succesfully", :attention)
    else
      redirect_to('/home', notice: "You are not authorized to release your current user.")
    end
  
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
