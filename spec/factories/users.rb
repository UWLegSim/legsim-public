FactoryBot.define do
  factory :user do
    email      { Faker::Internet.email     }
    first_name { Faker::Name.first_name    }
    last_name  { Faker::Name.last_name     }
#     password   { 'password'                }
#     password_confirmation { 'password'     }
    course
    association :last_chamber, factory: :chamber
  end
end
