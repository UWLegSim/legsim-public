class CoursesController < ApplicationController

  def index
    @courses = Course.all
  end

  def show
    @course = Course.find( params[:id] )
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new( course_params )

    if params[:new_institution_title] and params[:course][:institution_id].blank?
      @course.institution = Institution.create!( :name => params[:new_institution_title] )
    end

    @course.save ? redirect_to( @course ) : render(:action => :new)
  end

  def edit
    @course = Course.find( params[:id] )
  end


  def update
    @course = Course.find(params[:id])
    @course.update( course_params ) ?
      redirect_to( @course ) : render(:action => :edit)
  end


  def destroy
    Course.destroy( params[:id] )
    redirect_to( courses_path )
  end

  private
    
  def course_params
    params.require(:course).permit!
  end

end
