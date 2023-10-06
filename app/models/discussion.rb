class Discussion < ActiveRecord::Base

  belongs_to :group
  has_many :comments, -> { order("created_at DESC") }
  belongs_to :last_comment, :class_name => "Comment", optional: true

  belongs_to :creator, :class_name => "ChamberRole", optional: true
  belongs_to :referral

  scope :open_discussions,    -> { where( open: true ) }
  scope :closed_discussions,  -> { where( open: false ) }
  scope :public_discussions,  -> { where( private: false ) }
  scope :private_discussions, -> { where( private: true ) }

  scope :with_recent_comment, -> { where(['last_comment_at > ?', 2.weeks.ago ] ) }
  scope :include_chamber_role, -> { includes( last_comment: { chamber_role: :chamber } ) }

  def can_comment?( chamber_role )
    if open?
      true
    else
      false
    end
  end

  def title
    "#{group.name} - #{name}"
  end

  def most_recent_comment
    @most_recent_comment ||= comments.includes(:chamber_role).first
  end

  def set_to_close
    self.update!( :open => false )
  end

  def set_to_open
    self.update!( :open => true )
  end

  def last_event
    if most_recent_comment
      "commented"
    else
      "created the discussion"
    end
  end

  def last_event_chamber_role
    if most_recent_comment
      most_recent_comment.chamber_role
    else
      nil
    end
  end

  def last_event_timestamp
    last_comment_at ? last_comment_at : created_at
  end

end
