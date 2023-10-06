FactoryBot.define do
  factory :legislative_text do
    primary_text { Faker::Lorem.paragraph  }
    secondary_text { Faker::Lorem.paragraph  }
  end
end
