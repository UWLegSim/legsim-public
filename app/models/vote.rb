class Vote < ActiveRecord::Base

  belongs_to :motion
  belongs_to :group
  belongs_to :chamber
  has_one :referral, :through => :motion
#   belongs_to :scheduler, :class_name => 'ChamberRole'

  scope :pending,     -> { where(status: 'pending') }
  scope :in_progress, -> { where(status: 'in_progress') }
  scope :finished,    -> { where(status: 'finished') }
  scope :filibuster,  -> { where(status: 'filibuster') }
  scope :terminatd,   -> { where(status: 'terminatd') }

  scope :after_start_at,  -> { where(['start_at < ?',  Time.zone.now ]) }
  scope :after_finish_at, -> { where(['finish_at < ?', Time.zone.now ]) }

  has_many :ballots, :dependent => :delete_all
  has_many :yes_ballots
  has_many :no_ballots
  has_many :present_ballots

  before_validation :set_group_and_chamber, on: :create

  def set_group_and_chamber
    self.group = motion.referral&.group
    self.chamber = motion.referral&.group&.chamber
  end

  def title
    motion.title
  end

  def filibuster?
    status == 'filibuster'
  end

  def chart_url
    "http://chart.apis.google.com/chart?cht=p&chd=t:#{yes_percentage},#{no_percentage},#{present_percentage}&chs=230x130&chf=bg,s,FAFCFE&chco=268CE4,D12F2F,00AF1A&chl=Yes|No|Present"
  end

  def status_class
    if status == 'finished'
      outcome
    else
      status.underscore
    end
  end

  def threshold_to_text
    if threshold == 500
      "Simple Majority"
    elsif threshold == 600
      "60%"
    elsif threshold == 667
      "Two-Thirds Majority"
    elsif threshold == 1000
      "Unanimous Consent"
    end
  end

  def cancel
    self.destroy
  end

  def start

    self.status = 'in_progress'
    self.no_cache = 0
    self.yes_cache = 0
    self.present_cache = 0
    self.save

    issue_ballots
    notify_voters_of_start unless ENV['RAILS_ENV'] == 'test'

  end

  def update_calendar

    if motion.action == 'passage'

      all_calendar_referrals = CalendarReferral.where( referral_id: referral.id )
      all_calendar_referrals.each do |calendar_referral|
        calendar_referral.destroy if calendar_referral.group == referral.group
      end

    end

  end

  def issue_ballots

    referral.group.membership.each do |member|
      begin
        member.ballots.create!(
          :vote       => self,
          :preference => 'none'
        )
      rescue ActiveRecord::RecordNotUnique
        # we have already issued a ballot for this member, skip
      end
    end

  end

  def finish
    recount
    calculate_outcome
    process_outcome
    notify_voters_of_finish unless ENV['RAILS_ENV'] == 'test'
  end

  def notify_voters_of_start

    message_body = start_message_body

    ballots.each do |ballot|

      full_message = message_header(ballot.chamber_role,'Started') + message_body

      Net::SMTP.start('localhost') do |smtp|
        smtp.send_message full_message, ballot.motion.group.primary_leader ? ballot.motion.group.primary_leader.email : 'clerk@legsim.org', ballot.chamber_role.email
      end

    end

  end

  def notify_voters_of_finish

    message_body = finish_message_body

    ballots.each do |ballot|

      full_message = message_header(ballot.chamber_role,'Finished') + message_body

      Net::SMTP.start('localhost') do |smtp|
        smtp.send_message full_message, ballot.motion.group.primary_leader ? ballot.motion.group.primary_leader.email : 'clerk@legsim.org', ballot.chamber_role.email
      end

    end

  end


  def message_header(recipient,action)

    msg_header = <<END_OF_MESSAGE_HEADER
From: #{motion.group.primary_leader ? motion.group.primary_leader.clerk_envilope_address : '"LegSim Clerk" <clerk@legsim.org>'}
Sender: "LegSim Clerk" <clerk@legsim.org>
Reply-To: <no-reply@legsim.org>
Precedence: list
To: #{recipient.envilope_address}
Subject: [LegSim] Vote Regarding #{referral.legislation.reference} has #{action}

END_OF_MESSAGE_HEADER

    msg_header

  end

  def start_message_body

    msg = <<END_OF_MESSAGE
A vote has been started regarding #{referral.legislation.reference}.
The vote will conclude at #{finish_at.to_s(:long_with_time)}.

Please go to your LegSim Desk to cast your vote.
END_OF_MESSAGE

    msg

  end

  def finish_message_body

    msg = <<END_OF_MESSAGE
A vote regarding #{referral.legislation.reference} has finished.

Yes Votes: #{yes_tally}
No Votes: #{no_tally}
Present Votes: #{present_tally}

Outcome: #{outcome.titleize}

END_OF_MESSAGE

    msg

  end

  def calculate_outcome

    total_tally = yes_tally + no_tally
    total_tally += present_tally if absolute
    total_tally += none_tally if absolute

    if threshold == 500

      if total_tally == 0
        self.outcome = 'failed'
      elsif (yes_tally * 1000) / total_tally > threshold
        self.outcome = 'passed'
      else
        self.outcome = 'failed'
      end

    elsif threshold == 1000

      if no_tally > 0
        self.outcome = 'failed'
      else
        self.outcome = 'passed'
      end

    else

      if total_tally == 0
        self.outcome = 'failed'
      elsif (yes_tally * 1000) / total_tally >= threshold
        self.outcome = 'passed'
      else
        self.outcome = 'failed'
      end

    end

    self.save

  end

  def process_outcome

    if motion.action == 'passage'

      if outcome == 'passed'
        referral.legislation.approve!

        legislative_text = LegislativeText.create!( :primary_text => motion.text )
        report = Report.create!(
          :referral => referral,
          :reported_text => legislative_text
        )

      elsif outcome == 'failed'
        referral.legislation.reject!
      end

      referral.status = 'finished' if referral.group.is_floor?

    elsif motion.action == 'unanimous_consent_agreement' or motion.action == 'motion_to_proceed'

      referral.legislation.advance_with_consent if outcome == 'passed'

    elsif motion.action == 'cloture'

      referral.clear_filibusters if outcome == 'passed'

    elsif motion.action == 'report'

      referral.report.publish if outcome == 'passed'

    end

    referral.save

    self.status = 'finished'
    self.save

  end

  def recount
    self.yes_cache = ballots.yes.count
    self.no_cache = ballots.no.count
    self.present_cache = ballots.present.count
    self.save
  end

  def total_count
    yes_cache + no_cache + present_cache
  end

  def yes_tally
    yes_cache
  end

  def yes_percentage
    total_count > 0 ? ( yes_cache.to_f * 100 / total_count ).round_to(2) : 0
  end

  def no_tally
    no_cache
  end

  def no_percentage
    total_count > 0 ? ( no_cache.to_f * 100 / total_count ).round_to(2) : 0
  end

  def present_tally
    present_cache
  end

  def present_percentage
    total_count > 0 ? ( present_cache.to_f * 100 / total_count ).round_to(2) : 0
  end

  def none_tally
    ballots.none.count
  end

  def none_percentage
    total_count > 0 ? ( none_tally.to_f * 100 / total_count ).round_to(2) : 0
  end

end
