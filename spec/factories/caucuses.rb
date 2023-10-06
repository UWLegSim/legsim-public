FactoryBot.define do
  factory :caucus do
    name { Faker::Team.name }
    chamber
  end
end
