class Amendment < ActiveRecord::Base

  belongs_to :sponsor, class_name: 'Member'
  belongs_to :referral

  has_one :legislation, :through => :referral
  has_one :group, :through => :referral

  before_create :set_number

  def title
    "Amendment #{number}"
  end

  def title_with_group
    "#{group.name} Amendment #{number}"
  end

  def title_with_sponsor
    "Amendment #{number} - #{sponsor.title}"
  end

  private
  def set_number
    self.number = referral.group.amendments.count + 1
#     self.number = 1
  end

end
