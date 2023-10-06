class Letter < ActiveRecord::Base

  belongs_to :chamber_role
  belongs_to :chamber

  has_many :letter_user_recipients
  has_many :letter_group_recipients
  has_many :letter_meta_group_recipients

  before_validation :set_chamber, on: :create

  scope :unnotified, -> {where(notified:false)}
  scope :notified, -> {where(notified:true)}

  def set_chamber
    self.chamber = chamber_role.chamber
  end

  def sender_title
    chamber_role.title
  end

  def recipient_list

    letter_user_recipients.includes(:chamber_role).where( letter_group_recipient_id: nil, letter_meta_group_recipient_id: nil, blind: false ).collect do |recipient|
      recipient.chamber_role&.title
    end + letter_group_recipients.includes(:group).collect do |recipient|
      recipient.group&.title
    end + letter_meta_group_recipients.all.collect do |recipient|
      recipient.name&.titleize
    end

  end

  def recipient_string
    recipient_list.join(', ')
  end

  def to_html_tr
  end

end
