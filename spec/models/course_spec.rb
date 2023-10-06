require 'rails_helper'

RSpec.describe Course, type: :model do
  describe "display" do

    describe "#title" do

      it "joins the Course name with the Institution name" do

        course = FactoryBot.create(:course,
          name:        'Congress 09',
          institution: FactoryBot.create(:institution, name: 'UW')
        )

        expect(course.title).to eq('UW: Congress 09')

      end

    end

  end

end
