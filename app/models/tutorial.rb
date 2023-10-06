class Tutorial < ActiveRecord::Base

  belongs_to :chamber

  before_create :set_position

  def set_position
    self.position = chamber.tutorials.count + 1
  end

end
