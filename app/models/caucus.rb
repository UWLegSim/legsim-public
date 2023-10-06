class Caucus < Group

  def is_caucus?
    true
  end

  def primary_group_leader_title
    chamber.setting('primary_caucus_leader_title') || "Caucus Leader"
  end

end
