class Party < Group

  def is_party?
    true
  end

  def primary_group_leader_title
    chamber.setting('primary_party_leader_title') || "Party Leader"
  end

end
