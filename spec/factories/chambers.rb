FactoryBot.define do
  factory :chamber do
    name { Faker::Team.name }
    course
  end
end
