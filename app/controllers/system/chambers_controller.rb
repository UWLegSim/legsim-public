class System::ChambersController < SystemController

  before_action :set_chamber, only: [:show, :reinitialize, :edit, :update, :destroy, :export_content]

  def index
    if params[:course_id]
      @course = Course.find( params[:course_id] )
      @chambers = @course.chambers
    end
  end

  def show
  end

  def new
    if params[:course_id]
      @course = Course.find( params[:course_id] )
      @chamber = @course.chambers.new
    end
  end

  def create
    @chamber = Chamber.new( chamber_params )
    @chamber.save ? redirect_to( [:system,@chamber.course] ) : render(:action => :new)
  end

  def edit
  end

  def update
    @chamber.update(chamber_params) ?
      redirect_to( [:system,@chamber] ) : render(:action => :edit)
  end

  def reinitialize
    @chamber.reinitalize ?
      redirect_to( [:system,@chamber.course,@chamber] ) : render(:action => :show)
  end

  def destroy
    @chamber.destroy
    redirect_to( system_course_path( @chamber.course ) )
  end

  def export_content
    send_data( YAML.dump( chamber.export_content ), {
      :filename => 'content.yml',
      :type => 'text/yaml',
      :disposition => 'attachment'
    })
  end

  private 

    # Use callbacks to share common setup or constraints between actions.
    def set_chamber
      @chamber = Chamber.find(params[:id])
    end  

    # Never trust parameters from the scary internet, only allow the white list through.
    def chamber_params
      params.require(:chamber).permit(:name,:scenerio,:course_id)
    end 
end
