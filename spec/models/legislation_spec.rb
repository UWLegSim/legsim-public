require 'rails_helper'

RSpec.describe Legislation, type: :model do

  describe "scopes" do

    let(:chamber){FactoryBot.create(:chamber)}
    let(:committee){FactoryBot.create(:committee, chamber: chamber)}
    let(:legislative_type) {FactoryBot.create(:legislative_type, abbr: 'HR', name: 'Bill', chamber: chamber)}

    let(:legislation) {FactoryBot.create(:legislation, name: 'The Cheese Act', legislative_type: legislative_type)}
    let!(:floor_referral) {FactoryBot.create(:referral, legislation: legislation, group: chamber.floor)}
    let!(:committee_referral) {FactoryBot.create(:referral, legislation: legislation, group: committee)}

    let!(:floor_motion) {FactoryBot.create(:motion, referral: floor_referral)}
    let!(:floor_passage_motion) {FactoryBot.create(:motion, referral: floor_referral, action: 'passage')}
    let!(:committee_motion) {FactoryBot.create(:motion, referral: committee_referral)}

    let!(:floor_vote) {FactoryBot.create(:vote, motion: floor_motion)}
    let!(:floor_passage_vote) {FactoryBot.create(:vote, motion: floor_passage_motion)}
    let!(:committee_vote) {FactoryBot.create(:vote, motion: committee_motion)}

    describe "#referrals" do
      it "returns referrals" do
        expect( legislation.referrals).to eq([floor_referral,committee_referral])
      end
    end

    describe "#floor_referrals" do
      it "returns referrals to the floor" do
        expect( legislation.floor_referrals).to eq([floor_referral])
      end
    end

    describe "#motions" do
      it "returns motions for all referrals" do
        expect( legislation.motions).to eq([floor_motion,floor_passage_motion,committee_motion])
      end
    end

    describe "#floor_motions" do
      it "returns motions for floor referrals" do
        expect( legislation.floor_motions).to eq([floor_motion,floor_passage_motion])
      end
    end

    describe "#floor_passage_motions" do
      it "returns passage motions for floor referrals" do
        expect( legislation.floor_passage_motions).to eq([floor_passage_motion])
      end
    end

    describe "#votes" do
      it "returns votes for all motions" do
        expect( legislation.votes.to_a).to eq([floor_vote,floor_passage_vote,committee_vote])
      end
    end

    describe "#floor_votes" do
      it "returns votes for floor motions" do
        expect( legislation.floor_votes).to eq([floor_vote,floor_passage_vote])
      end
    end    

    describe "#floor_passage_votes" do
      it "returns votes for floor passage motions" do
        expect( legislation.floor_passage_votes).to eq([floor_passage_vote])
      end
    end    


  end

  describe "display" do

    describe "#title" do

      let(:legislative_type) {FactoryBot.create(:legislative_type, abbr: 'HR', name: 'Bill')}
      let(:legislation) {FactoryBot.create(:legislation, legislative_type: legislative_type, name: 'The Cheese Act')}

      it "joins legislative_type + number + title" do
        expect(legislation.title).to eq('HR1: The Cheese Act')
      end

      it "uses the cached title on second access" do
        legislation.title
        expect(legislation.title).to eq('HR1: The Cheese Act')
      end

    end

  end

  describe "#destroy" do

    it "destroys all associated referrals" do
      legislation = FactoryBot.create(:legislation)
      committee = FactoryBot.create(:committee, chamber: legislation.chamber)

      referral_1 = FactoryBot.create(:referral, group: committee, legislation: legislation)
      referral_2 = FactoryBot.create(:referral, group: committee, legislation: legislation)
      referral_3 = FactoryBot.create(:referral, group: committee, legislation: legislation)

      expect{legislation.destroy}.to change{ Referral.count }.by(-3)
    end

  end

  describe "#create" do

    it "assigns :number in order of creation scoped by LegislativeType" do
      legislative_type = FactoryBot.create(:legislative_type)

      legislation1 = FactoryBot.create(:legislation, legislative_type: legislative_type )
      legislation2 = FactoryBot.create(:legislation, legislative_type: legislative_type )
      legislation3 = FactoryBot.create(:legislation, legislative_type: legislative_type )

      expect(legislation1.number).to be(1)
      expect(legislation2.number).to be(2)
      expect(legislation3.number).to be(3)
    end

    it "creates a submission_text attribute of type LegislativeText" do

      legislation = FactoryBot.create(:legislation,
        submission_text: FactoryBot.create(:legislative_text)
      )

      expect(legislation.submission_text.class).to be(LegislativeText)

    end

  end

end
