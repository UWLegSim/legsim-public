class CalendarReferral < ActiveRecord::Base

  belongs_to :referral
  belongs_to :calendar
  has_one :group, :through => :referral
  has_one :legislation, :through => :referral

  before_create :set_position

  def set_position
    if calendar.calendar_referrals.empty?
      self.position = 0
    else
      self.position = calendar.calendar_referrals.last.position + 1
    end
  end

end
