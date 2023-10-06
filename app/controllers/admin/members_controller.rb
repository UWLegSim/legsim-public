class Admin::MembersController < AdminController

  def index
    @members = @current_chamber.members
  end

  def mass_delete
    if params[:chamber_role_ids].nil? or params[:chamber_role_ids].empty?
      flash_message("No members were selected.",:error)
    else
      params[:chamber_role_ids].each do |id|
        Member.destroy( id )
      end
      flash_message("#{"member".pluralize( params[:chamber_role_ids].count )} deleted.")
    end
    redirect_to( admin_members_path )
  end

  def mass_new

  end

  def mass_create
    fullnames_string = params[:fullnames]
    fullnames = fullnames_string.split(/\r*\n/)

    @users = []

    fullnames.each do |fullname|
      next if fullname =~ /^\s*$/
      firstname, lastname = fullname.split(' ',2)
      username = fullname.gsub(/\s+/,'-').downcase
      email = "#{username}-#{@current_chamber.course.id}@legsim.org"

      if @current_chamber.course.users.find_by_email( email )

        count = 1
        email = "#{username}#{count}-#{@current_chamber.course.id}@legsim.org"

        while @current_chamber.course.users.find_by_email( email )
          count += 1
          email = "#{username}#{count}-#{@current_chamber.course.id}@legsim.org"
        end

      end

      password = (0...8).collect { |n| ('a'..'z').to_a[rand(26)] }.join()

      user = User.new(
        :first_name => firstname,
        :last_name  => lastname,
        :email      => email,
        :course     => @current_chamber.course,
        :password              => password,
        :password_confirmation => password
      )
      user.skip_confirmation_notification!
      user.save
      user.confirm

      member = Member.create(
        :first_name => user.first_name,
        :last_name  => user.last_name,
        :chamber    => @current_chamber,
        :user       => user
      )

      @users.push( :user => user, :password => password )
    end

  end

end
