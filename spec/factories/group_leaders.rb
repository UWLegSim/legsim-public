FactoryBot.define do
  factory :group_leader do
    association :group, factory: :committee
    association :chamber_role, factory: :member
    title { Faker::Team.name }
    primary { false }
  end
end
