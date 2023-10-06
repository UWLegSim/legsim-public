class Referral < ActiveRecord::Base

  belongs_to :legislation
  belongs_to :referred_text, class_name: 'LegislativeText'
#   belongs_to :reported_text, class_name: 'LegislativeText'
  belongs_to :group
  belongs_to :referrer, class_name: 'ChamberRole', optional: true

  after_destroy :roll_back_referred_status
#   after_update :manage_discussion
  after_update :update_calendar

  has_one :report
  has_one :discussion

  has_one :calendar_referral
  has_one :calendar, through: :calendar_referral

  has_many :holds, dependent: :destroy
  has_many :amendments, dependent: :destroy
  has_many :motions, dependent: :destroy
  has_many :votes, through: :motions

  scope :committee, -> {joins(:group).where(['`groups`.`type` = ?', 'Committee'])}
  scope :caucus,    -> {joins(:group).where(['`groups`.`type` = ?', 'Caucus'])}
  scope :party,     -> {joins(:group).where(['`groups`.`type` = ?', 'Party'])}

  scope :organization, -> {joins(:group).where(['`groups`.`type` = ? OR `groups`.`type` = ?', 'Party', 'Caucus' ])}

  scope :standard, -> {where(['priority = ? OR priority = ?', 'primary', 'secondary'])}

  scope :primary,   -> {where(priority: 'primary')}
  scope :secondary, -> {where(priority: 'secondary')}
  scope :floor,     -> {where(priority: 'floor')}
  scope :special,   -> {where(priority: 'special')}
  scope :consent,   -> {where(priority: 'consent')}
  scope :rules,     -> {where(priority: 'rules')}

  scope :pending,   -> {where(status: 'pending')}
  scope :hearing,   -> {where(status: 'hearing')}
  scope :reported,  -> {where(status: 'reported')}
  scope :tabled,    -> {where(status: 'tabled')}
  scope :scheduled, -> {where(status: 'scheduled')}
  scope :finished,  -> {where(status: 'finished')}

  scope :unscheduled, -> {where(['status = ? OR status = ?', 'pending','hearing'])}
  scope :unreported, -> {where(['status <> ?', 'reported'])}

  scope :recent, -> {where([ "`referrals`.created_at > ?", 1.day.ago ])}

  def clear_filibusters

    votes.filibuster.each do |vote|
      vote.status = 'in_progress'
      vote.finish_at = vote.finish_at + ( Time.now - vote.held_at )
      vote.held_at = nil
      vote.save

      vote.motion.limited_debate = true
      vote.motion.save
    end

  end

  def manage_discussion( settings )

    case status
      when 'hearing' then
        if discussion.nil?
          open_discussion(
            chamber_role: settings[:chamber_role],
            private: false
          )
        else
          discussion.set_to_open
        end
      when 'tabled' then
        discussion.set_to_close if discussion
      when 'reported' then
        discussion.set_to_close if discussion
    end

  end

  def update_calendar
    if status == 'scheduled'
      calendar_referral.destroy if calendar_referral
    end
  end

  def open_discussion( options = {} )
    self.discussion = Discussion.create!(
      group: group,
      referral: self,
      # creator: options[:chamber_role],
      open: true,
      private: options[:private],
      name: discussion_name
    )
    self.save
  end

  def discussion_name

    if group.is_floor?
      "Floor Debate on #{legislation.reference}"
    else
      "Hearing on #{legislation.reference}"
    end

  end

  def legislation_with_group
    "#{legislation.short_title} (#{group.name})"
  end

  def accepts_ammendments?

    group.is_committee? or ( group.is_floor? and priority == 'floor' or priority == 'special' )

  end

  def roll_back_referred_status
    if legislation.referrals.count == 0
      legislation.status = 'introduced'
      legislation.save
    end
  end

end
