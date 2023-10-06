class Constituency < ActiveRecord::Base

  belongs_to :chamber
  has_many :member_profiles, :dependent => :nullify
  has_many :members, :through => :member_profiles

  def title
    "#{name} (#{abbr})"
  end

end
