class GroupMembershipRequest < ActiveRecord::Base

  belongs_to :group
  belongs_to :chamber_role

  scope :committees, -> {joins(:group).where(['groups.type = ?', 'Committee']).order(:rank)}
  scope :caucuses, -> {joins(:group).where(['groups.type = ?', 'Caucus'])}
  scope :parties, -> {joins(:group).where(['groups.type = ?', 'Party'])}
  scope :sections, -> {joins(:group).where(['groups.type = ?', 'Section'])}

end
