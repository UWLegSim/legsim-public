class MemberProfile < ActiveRecord::Base

  belongs_to :member
  belongs_to :constituency, optional: true

  validates :constituency_description, length: { maximum: 65535, too_long: "Your Constituency Description is too long." }

end
