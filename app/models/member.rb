class Member < ChamberRole

  has_one :member_profile, dependent: :destroy
  has_one :constituency, through: :member_profile, dependent: :destroy
  accepts_nested_attributes_for :member_profile, allow_destroy: true

#   def has_constituency?
#     if profile and profile.constituency
#       true
#     else
#       false
#     end
#   end

  def title

    if constituency and party
      suffix = " (#{party.abbr} - #{constituency.abbr})"
    elsif constituency
      suffix = " (#{constituency.abbr})"
    elsif party
      suffix = " (#{party.abbr})"
    else
      suffix = ""
    end

    "#{chamber.setting('member_title')} #{last_name}#{suffix}"

  end

  def is_member?
    true
  end

  def drafts
    []
  end

end
