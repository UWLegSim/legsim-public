FactoryBot.define do
  factory :institution do
    name { Faker::Educator.university }
  end
end
