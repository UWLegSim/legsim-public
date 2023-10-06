class Payment < ApplicationRecord
  belongs_to :user

  scope :paid, -> { where(status:"Paid") }

  def refundable?
    status == 'Paid'
  end

  def unmasked_cc_number=(v)
    self.cc_number = "************#{v[-4,4]}" unless v.blank?
  end

end
