require 'rails_helper'

RSpec.describe Group, type: :model do
  describe "leadership" do

    describe "#leaders" do

      it "returns all chamber_roles who are leaders for the group" do

        committee = FactoryBot.create(:committee)
        member1 = FactoryBot.create(:member)
        member2 = FactoryBot.create(:member)

        FactoryBot.create(:group_leader, group: committee, chamber_role: member1 )
        FactoryBot.create(:group_leader, group: committee, chamber_role: member2 )

        expect(committee.leaders).to eq([member1,member2])

      end

    end

    describe "#primary_leader" do

      it "returns one chamber_role who is the primary leader for the group" do

        committee = FactoryBot.create(:committee)
        member1 = FactoryBot.create(:member)
        member2 = FactoryBot.create(:member)

        FactoryBot.create(:group_leader, group: committee, chamber_role: member1 )
        FactoryBot.create(:group_leader, group: committee, chamber_role: member2, primary: true )


        expect(committee.primary_leader).to eq(member2)

      end

    end

  end

end
