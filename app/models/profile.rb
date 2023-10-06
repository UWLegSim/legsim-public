class Profile < ActiveRecord::Base
  belongs_to :chamber_role, polymorphic: true
end
