FactoryBot.define do
  factory :course do
    name { Faker::Educator.course }
    institution
    start_at { Time.now }
    finish_at { Time.now }
    archive_at { Time.now }
    time_zone { "Pacific Time (US & Canada)" }
    email { Faker::Internet.email }
  end
end
