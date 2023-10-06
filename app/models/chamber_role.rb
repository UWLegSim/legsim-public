class ChamberRole < ActiveRecord::Base

  belongs_to :chamber
  belongs_to :user
  accepts_nested_attributes_for :user, allow_destroy: true

  has_many :survey_answers, dependent: :destroy

  has_one :profile, dependent: :destroy
  has_one_attached :photo

  validates :photo, content_type: ['image/png', 'image/jpg', 'image/jpeg'],
                    dimension: { width: { min: 150, max: 2400 }, height: { min: 150, max: 1800 }, 
                    message: 'is not given between dimension' }

  has_many :sponsored_legislation, class_name: 'Legislation', foreign_key: 'sponsor_id', dependent: :destroy


  has_many :endorsements, class_name: 'LeadershipEndorsement', foreign_key: 'endorsed_chamber_role_id'

  has_many :cosponsorship, dependent: :destroy
  has_many :cosponsored_legislation, through: :cosponsorship, source: :legislation

  has_many :group_membership_requests, dependent: :destroy

  has_many :ballots, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :amendments, foreign_key: :sponsor_id, dependent: :destroy
  has_many :holds, dependent: :destroy
  has_many :filibusters, dependent: :destroy

  has_many :group_memberships, dependent: :destroy
  has_many :group_leaders, dependent: :destroy
  has_many :groups, through: :group_memberships

  has_many :letter_user_recipients, -> {order('created_at')}, dependent: :destroy
  has_many :sent_letters, class_name: 'Letter', dependent: :destroy
  has_many :received_letters, -> {order('letter_user_recipients.created_at DESC')}, class_name: 'Letter', through: :letter_user_recipients, source: :letter

  scope :include_user, -> {includes(:user)}

  def views_by_week
    user.views_by_week
  end

  def posts_by_week
    user.posts_by_week
  end

  def title
    name
  end

  def leadership_positions

    group_leaders.includes( :group ).collect do |gl|
      "#{gl.group.name} #{gl.title}" if gl.group
    end

  end

  def user_comments

    comments.includes(:group).collect do |uc|
      begin
        context = Discussion.find(uc.discussion_id)
          "#{uc.group.name} #{context.name} #{uc.content}"
      rescue
        ""
      end
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def envilope_address
    "\"#{name}\" <#{email}>"
  end

  def dear_colleague_envilope_address
    "\"#{name}\" <dear-colleague@legsim.org>"
  end

  def clerk_envilope_address
    "\"#{name}\" <clerk@legsim.org>"
  end

  def system_name
    "#{name} [ #{user.email} - #{type} ]"
  end

  def email
    user.email
  end

  def group_member?( group )
    if group.is_floor?
      true
    elsif GroupMembership.find_by_group_id_and_chamber_role_id( group.id, self.id )
      true
    end
  end

  def group_leader?( group )
    true if is_administrator? or group.group_leaders.find_by_chamber_role_id( id )
  end

  def committees
    groups.committees
  end

  def caucuses
    groups.caucuses
  end

  def party
    groups.parties.first
  end

  def section
    groups.sections.first
  end

  def committee_request_by_rank( rank )
    group_membership_requests.detect do |request|
      true if request.rank == rank and request.group.class == Committee
    end
  end

  def group_id_for_committee_request_by_rank( rank )
    request = committee_request_by_rank( rank )
    (request) ? request.group.id : nil
  end

  def can_administrate?
    false
  end

  def can_instruct?
    false
  end

  def number_of_endorsements( leadership_nomination )
    endorsements.find_all_by_leadership_nomination_id( leadership_nomination.id ).count
  end

  def ranked_committee_requests
    group_membership_requests.committees
  end

  def caucus_requests
    group_membership_requests.caucuses
  end

  def party_requests
    group_membership_requests.parties
  end

  def is_member?
    false
  end

  def is_administrator?
    false
  end

  def is_executive?
    false
  end

  def is_instructor?
    false
  end

  def preference_for_vote( vote )

    ballot = Ballot.find_by_vote_id_and_chamber_role_id(vote.id,id)

    if ballot
      ballot.preference
    else
      "none"
    end

  end

  def survey_answer?( survey_question, value )
    survey_answers.detect do |a|
      if a.survey_question_id == survey_question.id
        true if a.answer == value
      end
    end
  end

  def survey_answer_for_question( survey_question )
    answer = survey_answers.find_by_survey_question_id( survey_question.id )
    if answer
      answer.to_text
    else
      "N/A"
    end
  end

  def missed_roll_calls_as_percent

    total_ballots = ballots.count
    total_ballots > 0 ? ( ballots.none.count.to_f * 100 / total_ballots ).round_to(2).to_s + '%' : "N/A"

  end

end
