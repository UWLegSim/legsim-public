FactoryBot.define do
  factory :legislative_type do
    abbr { 'HR' }
    name { Faker::Team.name }
    chamber
  end
end
