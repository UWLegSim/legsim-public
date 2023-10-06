module ChamberRolesHelper

  def chamber_role_photo( chamber_role, options = {})

    settings = {
      :align => nil
    }.merge( options )

    if chamber_role.photo.attached?
      image_tag chamber_role.photo.variant(resize_to_fill: [150, 150]), :class => 'profile-pic', :alt => chamber_role.title, :title => chamber_role.title, :align => settings[:align]
    else
      image_tag '/assets/silhouette.png', :alt => chamber_role.title, :title => chamber_role.title, :align => settings[:align]
    end
  end

end
