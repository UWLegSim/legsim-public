class System::CoursesController < SystemController

  before_action :set_course, only: [:show, :edit, :update, :destroy]

  def index
    @active_courses = Course.active.includes(:institution).order("created_at DESC")
    @pending_courses = Course.pending.includes(:institution).order("created_at DESC")
    @inactive_courses = Course.inactive.includes(:institution).order("created_at DESC")
  end

  def archives
    @archive_courses = Course.archive.includes(:institution).order("created_at DESC")
  end

  def show
  end

  def new
    @course = Course.new(
      :start_at   => 1.day.from_now,
      :finish_at  => 3.months.from_now,
      :archive_at => 4.months.from_now
    )
  end

  def create
    @course = Course.new( course_params )

    if !params[:new_institution_name].blank? and params[:course][:institution_id] == 'new'
      @course.institution = Institution.create!( :name => params[:new_institution_name] )
    end

    @course.save ? redirect_to( [:system, @course] ) : render(:action => :new)
  end

  def edit
  end


  def update
    @course.update(course_params) ?
      redirect_to( [:system, @course] ) : render(:action => :edit)
  end


  def destroy
    @course.destroy
    redirect_to( courses_path )
  end

  private 

    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end  

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:institution_id, :name, :email, :time_zone, :payment_option, :start_at, :finish_at, :archive_at)
    end  
end
