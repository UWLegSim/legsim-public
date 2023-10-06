class LegislativeType < ActiveRecord::Base
  has_many :legislation
  has_many :submitted_legislation, -> {where(status: 'submitted')}, class_name: "Legislation"
  has_many :referred_legislation, -> {where(status: 'referred')}, class_name: "Legislation"

  belongs_to :chamber

  scope :submitable, -> {where(internal: false)}

  def title
    "#{name} (#{abbr})"
  end
end
