class DiscussionsController < ApplicationController

  def show
    @discussion = Discussion.find( params[:id] )
    authorize( :member_of => @discussion.group ) if @discussion.private?

    @page_title = "Discussion"
    @page_description = @discussion.title
  end

  def create

    discussion = Discussion.new( discussion_params )
    discussion.update(
      :open => true, :private => true,
      :creator => @current_chamber_role
    )
    discussion.save

    if discussion.group.is_caucus?
      flash_message("New caucus discussion has been started.")
      redirect_to manage_discussions_caucus_path(discussion.group)
    elsif discussion.group.is_party?
      flash_message("New party discussion has been started.")
      redirect_to manage_discussions_party_path(discussion.group)
    elsif discussion.group.is_committee?

      discussion.private = false
      discussion.save

      flash_message("New committee discussion has been started.")
      redirect_to manage_discussions_committee_path(discussion.group)
    end
  end

  def update
    discussion = Discussion.find( params[:id] )
    discussion.update(discussion_params)

    if discussion.group.is_caucus?
      flash_message("Discussion has been updated.")
      redirect_to manage_discussions_caucus_path(discussion.group)
    elsif discussion.group.is_party?
      flash_message("Discussion has been updated.")
      redirect_to manage_discussions_party_path(discussion.group)
    elsif discussion.group.is_committee?
      flash_message("Discussion has been updated.")
      redirect_to manage_discussions_committee_path(discussion.group)
    end

  end
    
  def discussion_params
    params.require(:discussion).permit!
  end           
end
