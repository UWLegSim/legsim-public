require 'rails_helper'

RSpec.describe Cosponsorship, type: :model do
  it "association sanity" do
    member = FactoryBot.create(:member)
    legislation = FactoryBot.create(:legislation)

    cosponsorship = Cosponsorship.create(
      chamber_role: member,
      legislation: legislation
    )

    expect(member.cosponsored_legislation.first).to eq(legislation)
    expect(legislation.cosponsors.first).to eq(member)
  end
end
