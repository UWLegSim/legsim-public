class MotionsController < ApplicationController

  def show
    @motion = Motion.find( params[:id] )

    @page_title = "Motion Regarding #{@motion.legislation.reference}"
    @page_description = @motion.action.titleize
  end

  def join_filibuster

    @motion = Motion.find( params[:id] )
    filibuster = Filibuster.find_or_create_by( motion_id: @motion.id, chamber_role_id: @current_chamber_role.id )

    if @motion.vote.status == 'filibuster'
      flash_message("You have joined the filibuster of #{@motion.title}")
    else
      flash_message("You have started the filibuster of #{@motion.title}")
      @motion.vote.status = 'filibuster'
      @motion.vote.held_at = filibuster.created_at
      @motion.vote.save
    end

    redirect_to motion_path( @motion )

  end

  def leave_filibuster

    @motion = Motion.find( params[:id] )
    filibuster = @motion.filibusters.find_by_chamber_role_id( @current_chamber_role.id )

    filibuster.destroy if filibuster

    if @motion.filibusters.empty?
      flash_message("You have ended the filibuster of #{@motion.title}")
      @motion.vote.status = 'in_progress'
      @motion.vote.finish_at = @motion.vote.finish_at + ( Time.now - @motion.vote.held_at )
      @motion.vote.held_at = nil
      @motion.vote.save
    else
      flash_message("You have left the filibuster of #{@motion.title}")
    end

    redirect_to motion_path( @motion )

  end

end
