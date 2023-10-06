class Instruction < ActiveRecord::Base

  belongs_to :chamber

  before_create :set_position

  def set_position
    self.position = chamber.instructions.count + 1
  end

end
