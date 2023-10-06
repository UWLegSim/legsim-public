class SurveyQuestion < ActiveRecord::Base

  belongs_to :chamber
  has_many :survey_answers

end
