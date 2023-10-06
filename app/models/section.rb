class Section < Group

  def is_section?
    true
  end

  def primary_group_leader_title
    chamber.setting('primary_section_leader_title') || "Section Leader"
  end

end
