class Committee < Group

  def is_committee?
    true
  end

  def primary_group_leader_title
    chamber.setting('primary_committee_leader_title') || "Chair"
  end

end
