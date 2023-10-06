class CreateSurveyAnswers < ActiveRecord::Migration[4.2]
  def self.up
    create_table :survey_answers do |t|
      t.integer :chamber_role_id
      t.integer :survey_question_id
      t.integer :answer
      t.timestamps
    end
  end

  def self.down
    drop_table :survey_answers
  end
end
