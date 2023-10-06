class TutorialsController < ApplicationController

  def index
    @tutorials = @current_chamber.tutorials
    @page_title = "Tutorials"
  end

  def show
    @tutorial = Tutorial.find( params[:id] )
    @page_title = @tutorial.title
    @page_description = @tutorial.summary
  end

end
