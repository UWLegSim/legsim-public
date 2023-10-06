FactoryBot.define do
  factory :party do
    name { Faker::Team.name }
    chamber
  end
end
