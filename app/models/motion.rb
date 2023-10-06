class Motion < ActiveRecord::Base

  belongs_to :referral
  belongs_to :chamber_role
  has_one    :vote, dependent: :destroy

  has_many :filibusters

  has_one :group, through: :referral
  has_one :legislation, through: :referral

  scope :without_vote, -> { includes(:vote).where("`votes`.`id` IS NULL") }

  def title
    if action == 'passage'
      "Passage of #{referral.legislation.reference}"
    elsif action == 'amendment'
      "Amendment to #{referral.legislation.reference}"
    elsif action == 'motion_to_proceed'
      "Motion to Proceed to the consideration of #{referral.legislation.reference}"
    elsif action == 'unanimous_consent_agreement'
      "Unanimous Consent to the consideration of #{referral.legislation.reference}"
    elsif action == 'cloture'
      "Cloture for #{referral.legislation.reference}"
    elsif action == 'report'
      "#{referral.group.type} Approval for #{referral.legislation.reference}"
    elsif action == 'general'
      "General Motion regarding #{referral.legislation.reference}"
    end
  end

  def display_action
    case action
      when 'passage'
        "Final Passage"
      when 'amendment'
        "Amendment"
      when 'motion_to_proceed'
        "Motion to Proceed"
      when 'unanimous_consent_agreement'
        "Unanimous Consent Agreement"
      when 'cloture'
        "Cloture"
    end
  end

  def can_filibuster?( chamber_role )
    hold = referral.holds.find_by_chamber_role_id( chamber_role )

    if hold
      (hold.created_at <= created_at) ? true : false
    else
      false
    end
  end

  def is_filibustering?( chamber_role )
    !filibusters.find_by_chamber_role_id( chamber_role.id ).nil?
  end

end
