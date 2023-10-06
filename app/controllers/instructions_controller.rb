class InstructionsController < ApplicationController

  def index
    @instructions = @current_chamber.instructions
    @page_title = "Instructions"
  end

  def show
    @instruction = Instruction.find( params[:id] )
    @page_title = @instruction.title
    @page_description = @instruction.summary
  end

end
