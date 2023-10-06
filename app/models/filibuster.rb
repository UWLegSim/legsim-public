class Filibuster < ActiveRecord::Base

  belongs_to :chamber_role
  belongs_to :motion

end
