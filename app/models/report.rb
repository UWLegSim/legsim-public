class Report < ActiveRecord::Base
  belongs_to :referral
  belongs_to :reported_text, class_name: 'LegislativeText'
  accepts_nested_attributes_for :reported_text, allow_destroy: true

  has_one :group, through: :referral
  has_one :legislation, through:  :referral

  def publish

    self.status = 'published'
    save!

    referral.status = 'reported'
    referral.save!

    if group.is_committee?

      if referral.priority == 'rules'
        legislation.update_special_rule( self )
      else
        legislation.update_calendar_status
      end

    end

  end

end
