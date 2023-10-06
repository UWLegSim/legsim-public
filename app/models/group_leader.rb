class GroupLeader < ActiveRecord::Base

  belongs_to :group
  belongs_to :chamber_role

end
