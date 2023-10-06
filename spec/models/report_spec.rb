require 'rails_helper'

RSpec.describe Report, type: :model do

  describe "#publish" do

    context "a special rule" do

      it "referals the rule to the floor for special consideration" do

        legislation = FactoryBot.create(:legislation)
        rules_committee = FactoryBot.create(:committee, chamber: legislation.chamber )

        special_rule = FactoryBot.create(:legislation,
          legislative_type: legislation.chamber.legislative_types.first,
          name: "Special Rule",
          status: "draft"
        )

        special_rule.relate( target: legislation, relation: "special_rule" )

        referral = FactoryBot.create(:referral,
          legislation: legislation,
          group:       rules_committee,
          status:      'hearing',
          priority:    'rules'
        )

        report = FactoryBot.create(:report, referral: referral)
        new_referral = report.publish

        expect(legislation.chamber.floor.referrals.rules.unscheduled).to eq([new_referral])

      end

    end

  end

end
