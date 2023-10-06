require 'rails_helper'

RSpec.describe Member, type: :model do
  it "creates a member" do
    chamber_role = FactoryBot.create(:member)
    expect(chamber_role.type).to  eq('Member')
  end
end
