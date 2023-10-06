class Course < ActiveRecord::Base

  belongs_to :institution
  has_many   :chambers, dependent: :destroy
  has_many   :users

  before_save :set_status

  validates_presence_of :name, :message => "Course must have a name."
  validates_presence_of :institution_id, :message => "Course must have an Institution."
  validates_presence_of :email, :message => "Course must have a course email address."
  validates_presence_of :time_zone, :message => "Course must have a time zone."
  validates_presence_of :start_at, :message => "Course must have a start date."
  validates_presence_of :finish_at, :message => "Course must have a finish date."
  validates_presence_of :archive_at, :message => "Course must have an archive date."

  scope :current, -> { where(status: 'pending').or( Course.where(status: 'active') ) }
  scope :pending,  -> { where(status: 'pending')  }
  scope :active,   -> { where(status: 'active')   }
  scope :inactive, -> { where(status: 'inactive') }
  scope :archive,  -> { where(status: 'archive')  }

  scope :accessible, -> { where(["status != ?",'archive']) }

  scope :to_be_made_pending,  -> { where(["start_at > ? AND status != ?",Time.now,'pending']) }
  scope :to_be_made_active,   -> { where(["start_at <= ? AND finish_at > ? AND status != ?",Time.now,Time.now,'active']) }
  scope :to_be_made_inactive, -> { where(["finish_at <= ? AND archive_at > ? AND status != ?",Time.now,Time.now,'inactive']) }
  scope :to_be_made_archive,  -> { where(["archive_at <= ? AND status != ?",Time.now,'archive']) }

  def payment_prepaid?
    payment_option == 'Prepaid'
  end

  def payment_elavon?
    payment_option == 'Elavon'
  end

  def payment_foliodirect?
    payment_option == 'FolioDirect'
  end

  def payment_uw_cforc?
    payment_option == 'UW Center for Commercialization'
  end

  def title
    "#{institution.name}: #{name}"
  end

  def set_status

    now = Time.now

    if now < start_at
      self.status = "pending"
    elsif now < finish_at
      self.status = "active"
    elsif now < archive_at
      self.status = "inactive"
    else
      self.status = "archive"
    end

    self

  end

end
