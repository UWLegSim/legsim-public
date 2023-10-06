require 'rails_helper'

RSpec.describe ChamberRole, type: :model do
  describe "#ranked_committee_requests" do
    before(:each) do
      chamber = FactoryBot.create(:chamber)

      committee1 = FactoryBot.create(:committee, chamber: chamber)
      committee2 = FactoryBot.create(:committee, chamber: chamber)
      caucus1 = FactoryBot.create(:caucus, chamber: chamber)
      caucus2 = FactoryBot.create(:caucus, chamber: chamber)
      party1 = FactoryBot.create(:party, chamber: chamber)
      party2 = FactoryBot.create(:party, chamber: chamber)

      @member = FactoryBot.build(:member, chamber: chamber)

      @request1 = committee1.make_request(@member, 2)
      @request2 = committee2.make_request(@member, 1)
      @request3 = caucus1.make_request(@member)
      @request4 = party2.make_request(@member)
    end

    it "returns committee requests in rank order" do
      expect(@member.ranked_committee_requests).to eq([@request2,@request1])
    end

    it "returns caucus requests" do
      expect(@member.caucus_requests).to eq([@request3])
    end

    it "returns party requests" do
      expect(@member.party_requests).to eq([@request4])
    end
  end
end
