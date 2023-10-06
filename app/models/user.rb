require 'digest/sha1'
require 'digest/md5'
require 'net/smtp'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable, :validatable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, authentication_keys: [:email,:course_id]

  validates_presence_of :email
  validates_format_of :email, with: /\A[^@\s]+@[^@\s]+\z/, allow_blank: true, if: :email_changed?
  validates_uniqueness_of :email, case_sensitive: false, allow_blank: true, if: :email_changed?, scope: :course_id

  belongs_to :course
  belongs_to :last_chamber, class_name: 'Chamber', optional: true

  has_many :chamber_roles, dependent: :destroy
  has_many :actions, dependent: :destroy
  has_many :payments

  after_create :generate_payment_token

  def self.make_activation_code( seed = nil )
    # make activation code by MD5ing a provided seed
    activation_code = Digest::MD5.hexdigest( seed )

    # if the code is already in use, generate a new code using the old code as a seed, otherwise pass the finished code back
    User.find_by_activation_code(activation_code) ? make_activation_code( activation_code ) : activation_code
  end

  def has_license?
    if course.payment_prepaid?
      true
    else
      payments.paid.any?
    end
  end

  def views_by_week

    views = []

    start_at = actions.get.first.created_at
    end_at = 1.week.since(start_at)

    while ( start_at < Time.now )

      views.push(
        {
          :week => "#{start_at.to_s(:short)} - #{end_at.to_s(:short)}",
          :count => actions.count(:all, :conditions => ['created_at > ? AND created_at <= ?',start_at,end_at])
        }
      )

      start_at = end_at
      end_at = 1.week.since(start_at)

    end

    views
  end

  def posts_by_week
    views = []

    start_at = actions.post.first.created_at
    end_at = 1.week.since(start_at)

    while ( start_at < Time.now )

      views.push(
        {
          :week => "#{start_at.to_s(:short)} - #{end_at.to_s(:short)}",
          :count => actions.count(:all, :conditions => ['created_at > ? AND created_at <= ?',start_at,end_at])
        }
      )

      start_at = end_at
      end_at = 1.week.since(start_at)

    end

    views
  end


  def chamber_role( chamber )
    ChamberRole.find_by_user_id_and_chamber_id( self.id, chamber.id )
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def title
    name
  end

  def send_activation_code

    message = <<END_OF_MESSAGE
From: LegSim <no-reply@legsim.org>
To: #{email}
Subject: LegSim Activation

Your account is ready, all you need to do is activate it by following this link:
#{activation_url}

After you have activated your account and set up your profile, we invite you to look around a little. Under 'members' you will find the ability to edit your profile, change your password, and take a look at other student's profiles. Under 'tutorials' you'll find extensive information about the legislative process and the roles of different kinds of legislators. Under 'instruction' you find examples of bills and committee hearings. Good luck!
END_OF_MESSAGE

    Net::SMTP.start('localhost') do |smtp|
    smtp.send_message message, 'no-reply@legsim.org', email
    end
  end

  def send_password_reset_code

    make_password_reset_code

    message = <<END_OF_MESSAGE
From: LegSim <no-reply@legsim.org>
To: #{email}
Subject: LegSim Password Reset

A request has been made to reset your password. To do so, follow this link and provide a new password:
#{password_reset_url}
END_OF_MESSAGE

    Net::SMTP.start('localhost') do |smtp|
      smtp.send_message message, 'no-reply@legsim.org', email
    end
  end

  def generate_payment_token
    if course.payment_uw_cforc?
      self.payment_token = id.to_s.crypt('7db8f9a8c1160469')
      save
    end
  end

  def generate_random_password
    (0...8).collect { |n| ('a'..'z').to_a[rand(26)] }.join()
  end

  def activation_url
    "http://#{APP_CONFIG['domain']}/activate/#{activation_code}"
  end

  def password_reset_url
    "http://#{APP_CONFIG['domain']}/reset_password/#{password_reset_code}"
  end

  protected

    def make_password_reset_code
      self.password_reset_code = self.class.make_token
      save
    end

    def make_activation_code

      self.deleted_at = nil
      self.activation_code = self.class.make_activation_code("#{email}#{course_id}")
      if course.payment_prepaid?
        send_activation_code
      elsif course.payment_foliodirect? or course.payment_uw_cforc?
        send_activation_code unless chamber_roles.first.is_member?
      end
    end
end
