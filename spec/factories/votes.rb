FactoryBot.define do
  factory :vote do
    motion
    threshold { 500 }
  end
end
