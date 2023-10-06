class Admin::InstructionsController < ApplicationController

  def index
    @instructions = @current_chamber.instructions
    @page_title = "Instruction Management"
  end

  def new
    @instruction = @current_chamber.instructions.new
  end

  def edit
    @instruction = Instruction.find( params[:id] )
  end

  def create
    @instruction = Instruction.new( instruction_params )
    if @instruction.save
      display_message("Instruction Created")
      redirect_to( admin_instructions_path )
    else
      render(:action => :new)
    end
  end

  def update
    @instruction = Instruction.find( params[:id] )
    if @instruction.update(instruction_params)
      display_message("Instruction Updated")
      redirect_to( edit_admin_instruction_path( @instruction ) )
    else
      render(:action => :edit)
    end
  end

  def destroy
    instruction = Instruction.destroy( params[:id] )
    flash_message("Instruction <b>#{instruction.title}</b> deleted.")
    redirect_to( admin_instructions_path )
  end

  def reorder
    current_chamber.instructions.each do |instruction|
      instruction.update(
        :position => params["instruction_#{instruction.id}"]
      )
    end
    flash_message("Instruction positions updated")
    redirect_to( admin_instructions_path )
  end

  def instruction_params
    params.require(:instruction).permit!
  end
end
