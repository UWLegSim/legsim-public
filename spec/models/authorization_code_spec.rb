require 'rails_helper'

RSpec.describe AuthorizationCode, type: :model do
  let(:chamber) {FactoryBot.create(:chamber)}

  describe "creation" do
    it "sets random code" do
      ac = AuthorizationCode.create( chamber: chamber )
      expect(ac.code.length).to eq(32)
    end
  end

  describe "member named_scope" do
    it "returns only those codes that are of chamber_role_type Member" do
      member_ac = AuthorizationCode.find_by( chamber: chamber, chamber_role_type: 'Member')
      expect(member_ac).to eq(chamber.member_authorization_code)
    end
  end

  describe "#create_chamber_role" do
    it "creates a chamber_role of the specified type" do
      user = FactoryBot.create(:user, course: chamber.course )
      member = chamber.member_authorization_code.create_chamber_role( user )

      expect(member.class).to be(Member)
      expect(member.chamber).to be(chamber)
      expect(member.user).to be(user)
    end
  end

end
