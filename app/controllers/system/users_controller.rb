class System::UsersController < SystemController

  include Devise::Controllers::SignInOut

  def index
    if params[:view] == 'all'
      @view = 'all'
      @courses = Course.includes(:chambers).order('created_at DESC')
    else
      @view = 'current'
      @courses = Course.current.includes(:chambers).order('created_at DESC')
    end
  end

  def show
    @user = User.find( params[:id] )
  end

  def find
    conditions = {}
    conditions[:email] = params[:email]           unless params[:email].blank?
    conditions[:first_name] = params[:first_name] unless params[:first_name].blank?
    conditions[:last_name] = params[:last_name]   unless params[:last_name].blank?
    conditions[:course_id] = params[:course_id]   unless params[:course_id].blank?

    @users = User.includes(course: :institution).where( conditions )
    @courses = Course.all
  end

  def destroy
    user = User.destroy( params[:id] )
    display_message("User #{user.name} has been deleted.")
    redirect_to( find_system_users_path( :course_id => user.course_id ) )
  end

  def send_confirmation
    if @user = User.find( params[:id] )
      @user.send_confirmation_instructions
      display_message("Confirmation email sent.")
      redirect_to( [:system,@user] )
    else
      display_message("No user was found.",:error)
      redirect_to( [:system,:users] )
    end
  end

  def update_password

    @user = User.find( params[:id] )
    @user.update( user_params )

    if @user.valid?
      @user.save
      flash_message("The user's password has been changed",:attention)
      redirect_to system_user_path( @user )
    else
      render 'show'
    end
  end

  def assume
    # this is a system_user assume path, so there's not possibility of releasing
    session[:previous_user_id] = nil

    chamber_role = ChamberRole.find( params[:chamber_role_id] )
    user = chamber_role.user

    if user.id == params[:id].to_i
      user.update( last_chamber: chamber_role.chamber )

      sign_in( user )

      redirect_to('/home')
      display_message("#{chamber_role.system_name} account assumed succesfully", :attention)
    else
      redirect_to('/system/users', notice: "The Chamber Role did not match the provided User, so the assume action was aborted.")
    end

  end

  def user_params
    params.require(:user).permit!
  end
end
