require 'rails_helper'

RSpec.describe Chamber, type: :model do

  let(:chamber) {FactoryBot.create(:chamber, name: 'House of Representatives')}
  
  describe "creation" do

    it "creates a Floor group" do
      expect(chamber.floor.type).to eq('Floor')
    end

    it "Floor group has the same name as the Chamber" do
      expect(chamber.floor.name).to eq(chamber.name)
    end

  end

  describe "initialization" do
    it "loads constituency data from a yaml file" do
      chamber.load_constituencies('us_house_of_representatives')
      expect(chamber.constituencies.count).to eq(435)
    end
  end

  describe "#reinitalize" do
    it "destroys and recreates the constintuencies" do
      expect { chamber.reinitalize }.to change { chamber.constituencies.count }.by(0)
    end

    it "disassociates profiles from constituencies" do
      first_constituency = chamber.constituencies.first
      profile = FactoryBot.create(:member_profile, constituency: first_constituency )
      expect { chamber.reinitalize }.to change { profile.reload.constituency }.from( first_constituency ).to( nil )
    end
  end

end
