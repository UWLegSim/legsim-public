class Calendar < ActiveRecord::Base

  belongs_to :group
  has_many :calendar_referrals, -> {order(:position)}
  has_many :referrals, through: :calendar_referrals

  def add_item( referral, chamber_role = nil )

#     unless referal = Referral.find_by_legislation_id_and_group_id( legislation.id, group.id )
#       referral = Referral.create!(
#         :legislation   => legislation,
#         :group         => group,
#         :referrer      => chamber_role,
#         :referred_text => legislation.submission_text,
#         :status        => 'pending',
#         :priority      => 'floor'
#       )
#     end

    calendar_referrals.create!( referral: referral )

  end

end
