require 'machinist/active_record'
require 'sham'

# user blueprints

Member.blueprint do
  user
  chamber
end

User.blueprint do
  email      { Faker::Internet.email     }
  login      { Faker::Internet.user_name }
  first_name { Faker::Name.first_name    }
  last_name  { Faker::Name.last_name     }
  password   { 'password'                }
  password_confirmation { 'password'     }
  course
end

# legislative blueprints

# Sponsorship.blueprint do
#   legislation
#   chamber_role { member }
# end

Cosponsorship.blueprint do
  legislation
  chamber_role { member }
end

Legislation.blueprint do
  name { Sham.name }
  legislative_type
  submission_text { LegislativeText.make }
end

LegislativeType.blueprint do
  abbr { 'HR' }
  name { Sham.name }
  chamber
end

LegislativeText.blueprint do
  primary_text { Sham.name }
  secondary_text { Sham.name }
end

Referral.blueprint do
  legislation
  group { Committee.make }
  referrer { Member.make }
  referred_text { LegislativeText.make }
end

Report.blueprint do
  referral
  reported_text { LegislativeText.make }
end

Calendar.blueprint do
  name { Sham.name }
  group
end

# Voting Blueprints

Motion.blueprint do
  referral
  chamber_role { Member.make }
end

Vote.blueprint do
  motion
  threshold { 500 }
end

Ballot.blueprint do
  vote
  chamber_role { Member.make }
end

# Organization Blueprints

Committee.blueprint do
  name { Sham.name }
  abbr { 'Com' }
  chamber
end

Caucus.blueprint do
  name { Sham.name }
  abbr { 'Cau' }
  chamber
end

Party.blueprint do
  name { Sham.name }
  abbr { 'Pat' }
  chamber
end

Floor.blueprint do
  name { Shame.name }
  abbr { 'WAM' }
  chamber
end

Chamber.blueprint do
  name { Sham.name }
  course
end

Course.blueprint do
  name { Sham.name }
  institution
  start_at { Time.now }
  finish_at { Time.now }
  archive_at { Time.now }
  time_zone { "Pacific Time (US & Canada)" }
  email { Sham.email }
end

Institution.blueprint do
  name { Sham.name }
end

GroupLeader.blueprint do
  group { Committee.make }
  chamber_role { Member.make }
  title { Sham.name }
  primary { false }
end

Sham.username { Faker::Internet.user_name }
Sham.email { Faker::Internet.email }
Sham.name { Faker::Name.name }
Sham.abbr { 'HR' }
# Sham.committee { Committee.make }
# Sham.member { Member.make }
# Sham.legislative_text { LegislativeText.make }