class Institution < ActiveRecord::Base

  has_many :courses

  validates_presence_of :name, :message => "Institution must have a name"


  def title
    name
  end

end
