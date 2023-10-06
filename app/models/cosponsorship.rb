class Cosponsorship < ActiveRecord::Base

  belongs_to :chamber_role
  belongs_to :legislation

end
