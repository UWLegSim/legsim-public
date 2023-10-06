require 'rails_helper'

RSpec.describe Institution, type: :model do

  describe "display" do

    describe "title" do

      it "uses the Institution name" do

        institution = FactoryBot.create(:institution, :name => 'UW' )
        expect(institution.title).to eq('UW')

      end

    end

  end

end
