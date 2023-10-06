class LegislationRelationship < ActiveRecord::Base

  belongs_to :target, :class_name => "Legislation"
  belongs_to :actor, :class_name => "Legislation"

  scope :special_rule, -> {where(relation: 'special_rule')}

end
