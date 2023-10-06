class Group < ActiveRecord::Base

  belongs_to :chamber
  has_many   :group_settings

  has_many :discussions, :dependent => :destroy
  has_many :comments, :through => :discussions

  has_many :group_memberships, :dependent => :destroy
  has_many :membership, :through => :group_memberships, :source => :chamber_role

  has_many :group_leaders, :dependent => :destroy
  has_many :leaders, :through => :group_leaders, :source => :chamber_role

  has_one :primary_group_leader, -> { where(['group_leaders.primary = ?','1']) }, :class_name => 'GroupLeader' 
  has_one :primary_leader, :through => :primary_group_leader, :source => :chamber_role

  has_many :secondary_group_leaders, -> { where(['group_leaders.primary = ?','0']) }, :class_name => 'GroupLeader'
  has_one  :secondary_leaders, :through => :secondary_group_leaders, :source => :chamber_role

  has_many :group_membership_requests, :dependent => :destroy

  has_many :leadership_nominations

  has_many :calendars

  has_many :referrals, :dependent => :destroy
  has_many :primary_referrals, -> { where(priority: 'primary') }, :class_name => 'Referral'
  has_many :secondary_referrals, -> { where(priority: 'secondary') }, :class_name => 'Referral'

  has_many :amendments, :through => :referrals
  has_many :motions, :through => :referrals
  has_many :votes
#   has_many :votes, :finder_sql =>  'SELECT votes.*
#                                       FROM referrals, motions, votes
#                                      WHERE referrals.group_id = #{id}
#                                        AND motions.referral_id = referrals.id
#                                        AND votes.motion_id = motions.id'
#
#   has_many :pending_votes, :class_name => "Vote",
#                            :finder_sql =>  'SELECT votes.*
#                                               FROM referrals, motions, votes
#                                              WHERE referrals.group_id = #{id}
#                                                AND motions.referral_id = referrals.id
#                                                AND votes.motion_id = motions.id
#                                                AND votes.status = "pending"'
#
#   has_many :in_progress_votes, :class_name => "Vote",
#                                :finder_sql =>  'SELECT votes.*
#                                                   FROM referrals, motions, votes
#                                                  WHERE referrals.group_id = #{id}
#                                                    AND motions.referral_id = referrals.id
#                                                    AND votes.motion_id = motions.id
#                                                    AND votes.status = "in_progress"'
#
#   has_many :filibuster_votes, :class_name => "Vote",
#                                :finder_sql =>  'SELECT votes.*
#                                                   FROM referrals, motions, votes
#                                                  WHERE referrals.group_id = #{id}
#                                                    AND motions.referral_id = referrals.id
#                                                    AND votes.motion_id = motions.id
#                                                    AND votes.status = "filibuster"'
#
#   has_many :finished_votes, :class_name => "Vote",
#                                :finder_sql =>  'SELECT votes.*
#                                                   FROM referrals, motions, votes
#                                                  WHERE referrals.group_id = #{id}
#                                                    AND motions.referral_id = referrals.id
#                                                    AND votes.motion_id = motions.id
#                                                    AND votes.status = "finished"'


  has_many :pending_referrals,  -> { where(status: 'pending') }, :class_name => 'Referral'
  has_many :reported_referrals, -> { where(status: 'reported') }, :class_name => 'Referral'

  scope :committees, -> { where(type:'Committee') }
  scope :caucuses, -> { where(type:'Caucus') }
  scope :parties, -> { where(type:'Party') }
  scope :sections, -> { where(type:'Section') }

  def title
    abbr.blank? ? name : "#{name} (#{abbr})"
  end

  def assign_primary_group_leader( chamber_role_id )

    if primary_group_leader
      if chamber_role_id != ''
        primary_group_leader.update!( :chamber_role_id => chamber_role_id )
      else
        primary_group_leader.destroy
      end
    elsif chamber_role_id != ''
      group_leaders.create!(
        :chamber_role_id => chamber_role_id,
        :title => primary_group_leader_title,
        :primary => true
      )
    end

  end

  def refer_legislation( legislation, priority = nil, chamber_role = nil )
    referral = referrals.create!(
      :legislation   => legislation,
      :referrer      => chamber_role,
      :referred_text => legislation.submission_text,
      :status        => 'pending',
      :priority      => priority
    )

    if legislation.status == 'introduced'
      legislation.status = 'referred'
      legislation.save!
    end

    referral
  end

  def add_member( chamber_role_id )
    group_memberships.find_or_create_by(chamber_role_id: chamber_role_id)
  end

  def remove_member( chamber_role_id )
    membership = GroupMembership.find_by(group_id: id, chamber_role_id: chamber_role_id )
    membership.destroy if membership
  end

  def make_request( chamber_role, rank = nil )

    group_membership_requests.create!(
      :chamber_role => chamber_role,
      :rank         => rank
    )

  end

  def is_member?( chamber_role )
    group_memberships.find_by( chamber_role_id: chamber_role.id )
  end

  def authorized?( options )

    options[:chamber_role] = @current_chamber_role unless options[:chamber_role]

    if primary_leader == options[:chamber_role]
      true
    else
      false
    end

  end

  def unassigned_chamber_roles
    chamber.members.reject do |chamber_role|
      true if chamber_role.group_member?( self )
    end
  end

#   require 'csv'
#   require ""

  def to_csv

    csv = CSV.generate do |csv|
      csv << [
        'First Name',
        'Last Name',
        'Comments Made',
        'Legislation Under Consideration',
        'Legislation Passed',
        'Legislation Cosponsored',
        'Amendments',
        'Leadership Post',
        '% Missed Roll Calls',
        'Dear Colleagues Sent',
        'Total Posts',
        'Total Views'
      ]

      membership.each do |member|
        csv << [
          member.first_name,
          member.last_name,
          member.user_comments.join(', '),
          member.sponsored_legislation.under_consideration.count,
          member.sponsored_legislation.passed.count,
          member.cosponsored_legislation.count,
          member.amendments.count,
          member.leadership_positions.join(', '),
          member.missed_roll_calls_as_percent,
          member.sent_letters.count,
          member.user.actions.post.count,
          member.user.actions.get.count
        ]
      end

    end

    csv

  end

  def is_committee?
    false
  end

  def is_caucus?
    false
  end

  def is_party?
    false
  end

  def is_floor?
    false
  end

  def setting( name, value = nil )

    @settings = {} unless @settings
    @settings[name] = group_settings.find_or_create_by(name: name) unless @settings[name]

    if value
      @settings[name].value = value
      @settings[name].save
    end

    @settings[name].value

  end


end
