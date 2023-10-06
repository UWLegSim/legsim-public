FactoryBot.define do
  factory :legislation do
    name { Faker::Team.name }
    legislative_type
    association :submission_text, factory: :legislative_text
    association :sponsor, factory: :member
  end
end
