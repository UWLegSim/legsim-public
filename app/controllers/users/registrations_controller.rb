# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create

    @authorization_code = AuthorizationCode.find_by_code( params[:authorization_code] )
    @agreement = (params[:user][:agreement] == '1') ? true : false

    if @authorization_code && @agreement

      @user = @authorization_code.chamber.course.users.new( user_params )
      if @user && @user.valid?
        @user.skip_confirmation_notification!
        @user.save!
        chamber_role = @authorization_code.create_chamber_role( @user )
      end

    else
      @user = User.new( user_params )
    end

    if @user.persisted? && @user.errors.empty? && chamber_role.errors.empty?

      session[:registered_user_id] = @user.id

      if chamber_role.is_member?

        if @user.course.payment_elavon?
          redirect_to payments_elavon_path
        elsif @user.course.payment_prepaid?
          @user.send_confirmation_instructions
          render 'payments/prepaid_complete'
        end

      else
        @user.send_confirmation_instructions
        render 'payments/prepaid_complete'
      end

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



    # super
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :agreement)
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
