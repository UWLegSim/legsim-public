class SurveyAnswer < ActiveRecord::Base

  belongs_to :chamber_role
  belongs_to :survey_question

  def to_text

    case answer
      when 1
        "Strongly Disagree"
      when 2
        "Disagree"
      when 3
        "Neither Agree Nor Disagree"
      when 4
        "Agree"
      when 5
        "Strongly Agree"
      else
        "N/A"
    end
  end

end
