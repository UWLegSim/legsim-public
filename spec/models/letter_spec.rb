require 'rails_helper'

RSpec.describe Letter, type: :model do
  it "sets_chamber at creation" do
    member = FactoryBot.create(:member)

    letter = Letter.create!(
      :chamber_role => member,
      :subject      => "Hello",
      "message"     => "Interesting Text"
    )

    expect(letter.chamber).to eq(member.chamber)
  end
end
