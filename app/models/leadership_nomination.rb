class LeadershipNomination < ActiveRecord::Base
  belongs_to :chamber
  belongs_to :chamber_role

  scope :open, -> {where(open: true)}
end
