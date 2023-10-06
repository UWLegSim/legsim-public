class CreateSurveyQuestions < ActiveRecord::Migration[4.2]
  def self.up
    create_table :survey_questions do |t|
      t.integer :chamber_id
      t.text    :question
      t.timestamps
    end
  end

  def self.down
    drop_table :survey_questions
  end
end
