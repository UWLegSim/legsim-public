require 'rails_helper'

RSpec.describe Vote, type: :model do

  describe "#set_group_and_chamber" do
    it "sets group and chamber at creation" do
      motion = FactoryBot.create(:motion)
      vote = FactoryBot.create(:vote, motion: motion )

      expect(vote.group).to eq(motion.group)
      expect(vote.chamber).to eq(motion.group.chamber)
    end
  end

#   describe "after_start_at" do
#
#     context "Pacific Time (US & Canada)" do
#
#       Time.zone = "Eastern Time (US & Canada)"
#
#       before = 1.hour.until( Time.now )
#       after = 1.hour.since( Time.now )
#
#       before_vote = Vote.make( :start_at => before )
#       after_vote = Vote.make( :start_at => after )
#
#       puts before_vote.start_at.to_s(:long_with_time)
#       Time.zone = "Pacific Time (US & Canada)"
#       puts before_vote.reload.start_at.to_s(:long_with_time)
#
#       Vote.after_start_at.should == [before_vote]
#
#     end
#
#   end

#   describe "#start" do
#     it "sets all the caches to zero" do
#       vote = Vote.make
#       vote.start
#
#       vote.no_cache.should == 0
#       vote.yes_cache.should == 0
#       vote.present_cache.should == 0
#
#     end
#
#     it "sets the status to in_progress" do
#       vote = Vote.make
#       vote.start
#
#       vote.status.should == 'in_progress'
#
#     end
#
#     it "issues ballots" do
#
#       committee = Committee.make
#
#       member1 = Member.make
#       member2 = Member.make
#       member3 = Member.make
#
#       committee.add_member( member1.id )
#       committee.add_member( member2.id )
#       committee.add_member( member3.id )
#
#       vote = Vote.make(
#         :motion => Motion.make(
#           :referral => Referral.make(
#             :group => committee
#           )
#         )
#       )
#
#       vote.start
#
#       vote.ballots.count.should == 3
#
#     end
#
#   end
#
#   describe "#finish" do
#
#     it "updates vote counts to final tallies" do
#       vote = Vote.make
#       vote.start
#
#       4.times { Ballot.make( :vote => vote, :preference => 'yes'     ) }
#       3.times { Ballot.make( :vote => vote, :preference => 'no'      ) }
#       2.times { Ballot.make( :vote => vote, :preference => 'present' ) }
#
#       vote.finish
#
#       vote.yes_tally.should == 4
#       vote.no_tally.should == 3
#       vote.present_tally.should == 2
#
#     end
#
#     it "calculates the outcome" do
#       vote = Vote.make
#       vote.start
#
#       4.times { Ballot.make( :vote => vote, :preference => 'yes'     ) }
#       3.times { Ballot.make( :vote => vote, :preference => 'no'      ) }
#       2.times { Ballot.make( :vote => vote, :preference => 'present' ) }
#
#       vote.finish
#       vote.outcome.should == 'passed'
#
#     end
#
#     context "when motion action is passage" do
#       it "updates legislation status" do
#
#         motion = Motion.make(:action => 'passage')
#         vote = Vote.make( :motion => motion )
#         vote.start
#
#         4.times { Ballot.make( :vote => vote, :preference => 'yes'     ) }
#         3.times { Ballot.make( :vote => vote, :preference => 'no'      ) }
#         2.times { Ballot.make( :vote => vote, :preference => 'present' ) }
#
#         vote.finish
#
#         motion.legislation.status.should == 'passed'
#
#       end
#
#       context "when legislation has 'special_rule' relationship" do
#         it "creates a 'special' referral to the floor" do
#
#           legislation = Legislation.make
#           motion = Motion.make(:action => 'passage')
#
#           LegislationRelationship.create(
#             :actor  => motion.legislation,
#             :target => legislation,
#             :relation => 'special_rule'
#           )
#
#           legislation.referrals.special.count.should == 0
#
#           vote = Vote.make( :motion => motion )
#           vote.start
#
#           4.times { Ballot.make( :vote => vote, :preference => 'yes'     ) }
#           3.times { Ballot.make( :vote => vote, :preference => 'no'      ) }
#           2.times { Ballot.make( :vote => vote, :preference => 'present' ) }
#
#           vote.finish
#
#           legislation.referrals.special.count.should == 1
#         end
#
#         it "removes related legislation from the calendar" do
#
#           legislation = Legislation.make
#           calendar = Calendar.make( :group => legislation.chamber.floor )
#           referral = legislation.chamber.floor.refer_legislation( legislation, 'floor' )
#           calendar.add_item( referral )
#
#           motion = Motion.make(:action => 'passage')
#
#           LegislationRelationship.create(
#             :actor  => motion.legislation,
#             :target => legislation,
#             :relation => 'special_rule'
#           )
#
#           vote = Vote.make( :motion => motion )
#           vote.start
#
#           4.times { Ballot.make( :vote => vote, :preference => 'yes'     ) }
#           3.times { Ballot.make( :vote => vote, :preference => 'no'      ) }
#           2.times { Ballot.make( :vote => vote, :preference => 'present' ) }
#
#           legislation.floor_calendar.should_not == nil
#           vote.finish
#           legislation.floor_calendar.should == nil
#         end
#
#       end
#     end
#
#   end

end
