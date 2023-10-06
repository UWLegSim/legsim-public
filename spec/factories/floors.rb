FactoryBot.define do
  factory :floor do
    name { Faker::Team.name }
    chamber
  end
end
