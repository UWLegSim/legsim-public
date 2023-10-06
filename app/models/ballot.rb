class Ballot < ActiveRecord::Base

  belongs_to :vote
  belongs_to :chamber_role

  has_one :motion, through: :vote

  scope :open, -> {joins(:vote).where(['`votes`.`status` = ? OR `votes`.`status` = ?','in_progress','filibuster'])}
  scope :organization, -> {joins(:group).where(['`groups`.`type` = ? OR `groups`.`type` = ?', 'Party', 'Caucus' ])}

  scope :yes, -> {where(preference: 'yes')}
  scope :no, -> {where(preference: 'no')}
  scope :present, -> {where(preference: 'present')}
  scope :no_preference, -> {where(preference: 'none')}
  scope :voted, -> {where(['`preference` != ?','none'])}

end
