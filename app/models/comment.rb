class Comment < ActiveRecord::Base

  belongs_to :chamber_role
  belongs_to :discussion, counter_cache: true
  has_one :group, :through => :discussion

end
