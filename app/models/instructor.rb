class Instructor < ChamberRole

  def sections
    chamber.sections.includes(:group_leaders).where( group_leaders: { chamber_role_id: id } )
  end

  def is_instructor?
    true
  end

  def can_instruct?
    true
  end

end
