class Admin::UsersController < AdminController

  def index
    @page_title = "Manage Users"
    @chamber_roles = current_chamber.chamber_roles.includes( :user )
  end

  def edit_password
    @page_title = "Reset Password"
    @user = User.find( params[:id] )
    @page_description = @user.name
  end

  def update_password

    @user = User.find( params[:id] )
    @user.update( user_params )

    if @user.valid?
      @user.save
      flash_message("Password for #{@user.name} has been changed.",:attention)
      redirect_to admin_users_path
    else
      render 'edit_password'
    end
  end

  def send_password_reset

    user = User.find( params[:id] )
    user.send_password_reset_code

    flash_message("Password reset for #{user.name} sent to #{user.email}.",:attention)
    redirect_to admin_users_path

  end

  def user_params
    params.require(:user).permit!
  end
end
