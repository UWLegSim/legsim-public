# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def link_to_user( user )

    if user

      if user.class == User
        user.title
      else
        if user.class == Member
          "#{user.chamber.setting('member_title')} #{link_to(user.last_name,member_path(user))}".html_safe
        else
          user.title
        end
      end

    else
      "None"
    end
  end

  def link_to_group( group )
    if group.is_committee?
      link_to( group.name, committee_path( group ) )
    elsif group.is_caucus?
      link_to( group.name, caucus_path( group ) )
    elsif group.is_party?
      link_to( group.name, party_path( group ) )
    elsif group.is_floor?
      link_to( group.name, floor_path( group ) )
    elsif group.is_section?
      link_to( group.name, section_path( group ) )
    end
  end

  def link_to_tool(name, description, options = {},html_options = {})
    link_to( "<div class='title'>#{name}</div><div class='description'>#{description}</div>".html_safe, options, html_options )
  end

  def link_to_legislation( legislation )
    "#{link_to( legislation.reference, legislation_path( legislation ) ) }: #{legislation.name}".html_safe
  end

  def graphic_submit_tag(text,options = {})

    settings = {
      :size => 'thirty',
    }.merge(options)

    "<div class='button #{settings[:size]}'><div class='left'><div class='right'>#{submit_tag( text, :class => "submit") }</div></div></div>"
  end

  def content( reference )
    content = Content.find_by_reference_and_chamber_id( reference, @current_chamber.id )
    if content
      edit_link = (!@current_chamber_role.nil? and @current_chamber_role.is_administrator?) ? link_to( "Edit Content", edit_admin_content_path( content ), :class => 'edit-content' ) : ''
      ( content.copy + edit_link ).html_safe
    else
      edit_link = (!@current_chamber_role.nil? and @current_chamber_role.is_administrator?) ? link_to( "Create Content", new_admin_content_path( :reference => reference ), :class => 'edit-content' ) : ''
      ( 'No Content Found' + edit_link ).html_safe
    end
  end

end
