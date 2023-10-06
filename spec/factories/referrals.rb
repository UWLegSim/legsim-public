FactoryBot.define do
  factory :referral do
    legislation
    association :group, factory: :committee
    association :referrer, factory: :member
    association :referred_text, factory: :legislative_text
  end
end
