class MembersController < ApplicationController

  def index
    @chamber = @current_chamber
    @page_title = "Membership"
    @page_description = @chamber.name
  end

  def show
    @member = Member.find( params[:id] )
    @page_title = "Public Office"
    @page_description = @member.name
  end

  def details
    @member = Member.find( params[:id] )
    @page_title = "Details"
    @page_description = @member.name
  end

  def edit
    @member = Member.find( params[:id] )


    @member.create_member_profile unless @member.member_profile
    if @current_chamber_role
      render
    else
      render(:action => :new, :layout => 'public')
    end
  end

  def update
    @member = Member.find(params[:id])
    if @member.update(member_params)
      
      @member.photo.purge if params[:delete_photo]

      @member.chamber.survey_questions.each do |q|
        if value = params["q#{q.id}"]
          survey_answer = @member.survey_answers.find_or_initialize_by( survey_question_id: q.id )
          survey_answer.answer = value
          survey_answer.save!
        end
      end

      display_message("Profile Updated")
      redirect_to( @member.user )
    else
      display_message("Profile Update Failed",:error)

      @member.errors.messages.each_pair do |attribute,messages|
        messages.each do |message|
          display_message(message,:error)
        end
      end

      render(:action => :edit)
    end
  end

  def member_params
    params.require(:member).permit!
  end
end
