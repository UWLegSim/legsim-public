FactoryBot.define do
  factory :committee do
    name { Faker::Team.name }
    chamber
  end
end
