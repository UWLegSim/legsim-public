class CommentsController < ApplicationController

  def create
    @comment = Comment.new( comment_params )
    @comment.chamber_role = @current_chamber_role
    @discussion = Discussion.find(@comment.discussion_id)

    @comment.save
    @discussion.last_comment_id = @comment.id
    @discussion.last_comment_at = @comment.created_at
    @discussion.save

    flash_message("Your comment has been posted.")

    if @comment.discussion.referral
      redirect_to( @comment.discussion.referral )
    else
      redirect_to( @comment.discussion )
    end
  end

  def comment_params
    params.require(:comment).permit!
  end
end
