FactoryBot.define do
  factory :report do
    referral
    association :reported_text, factory: :legislative_text
  end
end
