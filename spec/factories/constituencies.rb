FactoryBot.define do
  factory :constituency do
    sequence(:name) { |n| "United States #{n}" }
    sequence(:abbr) { |n| "US #{n}" }
    chamber
  end
end
