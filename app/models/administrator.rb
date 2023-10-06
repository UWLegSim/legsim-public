class Administrator < ChamberRole

  def can_administrate?
    true
  end

  def can_instruct?
    true
  end

  def is_administrator?
    true
  end
end
