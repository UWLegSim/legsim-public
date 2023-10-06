class Legislation < ActiveRecord::Base

  validates_presence_of :legislative_type, :submission_text, :sponsor

  belongs_to :legislative_type
  has_one :chamber, through: :legislative_type

  belongs_to :submission_text, class_name: 'LegislativeText'
  accepts_nested_attributes_for :submission_text, allow_destroy: true

  has_many :referrals, dependent: :destroy
  has_many :motions, through: :referrals
  has_many :amendments, through: :referrals
  has_many :votes, through: :motions

  has_many :floor_referrals, -> (legislation) { where( group_id: legislation.chamber.floor ) }, class_name: 'Referral'
  has_many :floor_motions, through: :floor_referrals, source: :motions, class_name: 'Motion'
  has_many :floor_votes, through: :floor_motions, source: :vote, class_name: 'Vote'

  has_many :floor_passage_motions, -> { where(action: "passage") }, through: :floor_referrals, source: :motions, class_name: 'Motion'
  has_many :floor_passage_votes, through: :floor_passage_motions, source: :vote, class_name: 'Vote'

  has_many :target_legislation_relationships, foreign_key: :actor_id, class_name: "LegislationRelationship"
  has_many :related_target_legislation, through: :target_legislation_relationships, source: :target

  has_many :actor_legislation_relationships, foreign_key: :target_id, class_name: "LegislationRelationship"
  has_many :related_actor_legislation, through: :actor_legislation_relationships, source: :actor

  has_many :pending_referrals, -> {where(status: 'pending')}, class_name: 'Referral'
  has_many :reported_referrals, -> {where(status: 'reported')},  class_name: 'Referral'

  belongs_to :sponsor, class_name: 'ChamberRole'

  def floor_vote
    @floor_vote ||= floor_passage_votes.finished.first
  end

  has_many :cosponsorships
  has_many :cosponsors, through: :cosponsorships, source: :chamber_role

  before_create :set_number
  before_create :set_status

  scope :under_consideration, -> {where(['status = ? OR status = ? OR status = ?','introduced','referred','calendar'])}
  scope :active, -> {where(['status != ?','withdrawn'])}

  scope :introduced, -> {where(status: 'introduced')}
  scope :referred,   -> {where(status: 'referred')}
  scope :calendar,   -> {where(status: 'calendar')}
  scope :passed,     -> {where(status: 'passed')}
  scope :failed,     -> {where(status: 'failed')}

  def self.search( query )

    puts query.inspect


    unless query[:status].empty? and query[:legislative_type_ids].empty?

      conditions = { legislative_types: { chamber_id: query[:chamber_id] } }
      conditions[:legislative_type_id] = query[:legislative_type_ids] unless query[:legislative_type_ids].empty?
      conditions[:status] = query[:status] unless query[:status].empty?

      puts conditions.inspect

      Legislation.includes(:legislative_type).where( conditions )

    else
      []
    end

  end

  def title
    @title = "#{reference}: #{name}" if @title.nil?
    @title
  end

  def short_title
    (title.length > 40) ? "#{title[0,40]}..." : title
  end

  def short_title_with_holds
    if referrals.floor.last.nil?
      short_title
    else

      if referrals.floor.last.holds.count > 1
        "#{short_title} (#{referrals.floor.last.holds.count} hold)"
      elsif referrals.floor.last.holds.count == 1
        "#{short_title} (1 hold)"
      else
        short_title
      end

    end
  end


  def reference
    "#{legislative_type.abbr}#{number.to_s}"
  end

  def reject!
    self.status = 'failed'
    self.save
  end

  def approve!
    self.status = 'passed'
    self.save

    target_legislation_relationships.each do |target_relationship|

      if target_relationship.relation == 'special_rule'

        target_relationship.target.advance_with_special_rule

      end

    end

  end

  def advance_with_consent

    referral = referrals.find_or_create_by( group_id: chamber.floor.id )
    referral.priority = 'consent'
    referral.save

    floor_calendar.destroy if floor_calendar

  end

  def advance_with_special_rule

    referral = referrals.find_or_create_by( group_id: chamber.floor.id )
    referral.priority = 'special'
    referral.save

    floor_calendar.destroy if floor_calendar

  end

  def update_special_rule( report )
    self.submission_text.primary_text = report.reported_text.primary_text
    submission_text.save

    self.status = 'calendar'
    self.save!

    chamber.floor.refer_legislation(self,'rules',report.referral.referrer)
  end

  def update_calendar_status

    if referrals.committee.primary.unreported.empty?
      chamber.floor.refer_legislation(self,'floor')
      self.update!( status: 'calendar' )
    end

  end

  def relate(options)
    target_legislation_relationships.create!(
      target: options[:target],
      relation: options[:relation]
    )
  end

  def floor_calendar
    referrals.floor.last ? referrals.floor.last.calendar : nil
  end

  def is_cosponsor?( chamber_role )
    cosponsorships.find_by_chamber_role_id( chamber_role.id )
  end

  def can_cosponsor?( chamber_role )
    if sponsor == chamber_role
      false
    elsif chamber_role.is_member?
      true
    else
      false
    end
  end

  def add_cosponsor( chamber_role )
    unless is_cosponsor?( chamber_role )
      cosponsorships.create!(
        chamber_role: chamber_role
      )
    end
  end

  def remove_cosponsor( chamber_role )
    cosponsorship = is_cosponsor?( chamber_role )
    cosponsorship.destroy if cosponsorship
  end

  private
  def set_number
    last_number = Legislation.where( legislative_type_id: legislative_type.id ).last.try(:number) || 0
    self.number =  last_number + 1
  end

  def set_status
    self.status = 'introduced' unless status
  end

end
