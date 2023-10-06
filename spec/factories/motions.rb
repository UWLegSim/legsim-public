FactoryBot.define do
  factory :motion do
    referral
    association :chamber_role, factory: :member
  end
end
