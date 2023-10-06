class Admin::ChambersController < ApplicationController

  def show
    @chamber = params[:id] ? Chamber.find( params[:id] ) : @current_chamber
  end

  def edit_contents
    @chamber = Chamber.find( params[:id] )
  end

  def update_contents
    @chamber = Chamber.find( params[:id] )
    redirect_to( new_referrals_admin_chamber_path( @chamber ) )
  end

  def new_referrals
    @chamber = Chamber.find( params[:id] )
  end

  def create_referrals
    @chamber = Chamber.find( params[:id] )
    group = Group.find( params[:group_id] )

    params['legislation_ids'].each do |legislation_id|
      unless group.referrals.find_by_legislation_id( legislation_id )
        legislation = Legislation.find( legislation_id )
        group.refer_legislation( legislation )
      end
    end if params['legislation_ids']

    redirect_to( new_referrals_admin_chamber_path( @chamber ) )
  end

  def edit_survey_questions
    @chamber = Chamber.find( params[:id] )
  end

  def init_survey_questions
    @chamber = Chamber.find( params[:id] )
    @chamber.load_survey_questions( @chamber.scenerio )

    display_message("Survey Questions have been reloaded",:attention)
    redirect_to( edit_survey_questions_admin_chamber_path( @chamber ) )
  end

  def update_survey_questions

  end


  def edit_constituencies
    @chamber = Chamber.find( params[:id] )
  end

  def init_constituencies
    @chamber = Chamber.find( params[:id] )
    @chamber.load_constituencies( @chamber.scenerio )

    display_message("Constituencies have been reloaded",:attention)
    redirect_to( edit_constituencies_admin_chamber_path( @chamber ) )
  end

  def update_constituencies

  end

  def edit_committees
    @chamber = Chamber.find( params[:id] )
  end

  def init_committees
    @chamber = Chamber.find( params[:id] )
    @chamber.load_committees( @chamber.scenerio )

    display_message("Committees have been reloaded",:attention)
    redirect_to( edit_committees_admin_chamber_path( @chamber ) )
  end

  def update_committees

  end

  def edit_legislative_types
    @chamber = Chamber.find( params[:id] )
  end

  def init_legislative_types
    @chamber = Chamber.find( params[:id] )
    @chamber.load_legislative_types( @chamber.scenerio )

    display_message("Legislative Types have been reloaded",:attention)
    redirect_to( edit_legislative_types_admin_chamber_path( @chamber ) )
  end

  def update_legislative_types

  end

  def edit_chamber_roles
    @chamber = Chamber.find( params[:id] )
  end

  def update_chamber_roles
    @chamber = Chamber.find( params[:id] )

    if params['chamber_role_class'].blank?
      chamber_role_class = false
    else
      chamber_role_class = params['chamber_role_class'].constantize
    end

    params['user_ids'].each do |user_id|

      chamber_role_class.create!(
        :user_id => user_id,
        :chamber => @chamber
      ) if chamber_role_class

    end if params['user_ids']

    ['member','administrator'].each do |role_type|
      params["#{role_type}_user_ids"].each do |user_id|

        chamber_role = User.find( user_id ).chamber_role( @chamber )
        chamber_role.destroy if chamber_role

        chamber_role_class.create!(
          :user_id => user_id,
          :chamber => @chamber
        ) if chamber_role_class

      end if params["#{role_type}_user_ids"]
    end

    redirect_to( edit_chamber_roles_admin_chamber_path( @chamber ) )
  end

end
