class Executive < ChamberRole

  has_one :executive_profile
  accepts_nested_attributes_for :executive_profile, :allow_destroy => true

  def title
    "#{chamber.setting('executive_title')} #{last_name}"
  end

  def is_executive?
    true
  end

end
