class Hold < ActiveRecord::Base

  belongs_to :chamber_role
  belongs_to :referral
  has_one :legislation, :through => :referral

end
