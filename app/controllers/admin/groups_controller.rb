class Admin::GroupsController < AdminController

#   def edit_membership
#     @group = Group.find( params[:id] )
#   end
#
#   def update_membership
#     @group = Group.find( params[:id] )
#
#     if params['add_chamber_role_ids']
#       params['add_chamber_role_ids'].each do |chamber_role_id|
#         @group.add_member( chamber_role_id )
#       end
#     elsif params['remove_chamber_role_ids']
#       params['remove_chamber_role_ids'].each do |chamber_role_id|
#         @group.remove_member( chamber_role_id )
#       end
#     end
#
#     redirect_to( edit_membership_admin_group_path( @group ) )
#   end
#
  def edit_leadership
    @caucuses = current_chamber.caucuses
    @committees = current_chamber.committees
    @parties = current_chamber.parties
    @floor = current_chamber.floor
    @page_title = "Assign Group Leadership"
  end

  def update_leadership

    current_chamber.groups.each do |group|
      chamber_role_id = params["group_#{group.id}"]
      group.assign_primary_group_leader( chamber_role_id )
    end

    flash_message("New group leadership has been assigned",:notice)
    redirect_to( edit_leadership_admin_groups_path )
  end
#
#   def edit_committee_leadership
#     @committees = @current_chamber.committees
#     @page_title = "Assign Committee Leadership"
#   end
#
#   def update_committee_leadership
#
#     @current_chamber.committees.each do |group|
#       chamber_role_id = params["group_#{group.id}"]
#       group.assign_primary_group_leader( chamber_role_id )
#     end
#
#     flash_message("New committee leadership has been assigned",:notice)
#     redirect_to( edit_committee_leadership_admin_groups_path )
#   end
#
#   def edit_party_leadership
#     @parties = @current_chamber.parties
#     @page_title = "Assign Party Leadership"
#   end
#
#   def update_party_leadership
#
#     @current_chamber.parties.each do |group|
#       chamber_role_id = params["group_#{group.id}"]
#       group.assign_primary_group_leader( chamber_role_id )
#     end
#
#     flash_message("New party leadership has been assigned",:notice)
#     redirect_to( edit_party_leadership_admin_groups_path )
#   end

end
