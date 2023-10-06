FactoryBot.define do
  factory :member_profile do
    member
    constituency
    personal_statement { "I an the best" }
    constituency_description { "So are the people I represent" }
  end
end
