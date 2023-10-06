class Floor < Group

  def primary_group_leader_title
    chamber.setting('primary_floor_leader_title') || "Speaker"
  end

  def referrals_pending_calendar

    referrals.floor.select do |referral|
      referral.calendar_referral.nil? && referral.legislation.status != 'failed' &&
      referral.legislation.status != 'vetoed' && referral.legislation.status != 'passed' && referral.legislation.status != 'law'
    end

  end

  def is_floor?
    true
  end

  def membership
    chamber.members
  end

end
