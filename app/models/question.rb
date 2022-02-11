class Question < ApplicationRecord
  QUESTION_LEVELS = (0..14).freeze

  validates :level, presence: true, inclusion: { in: QUESTION_LEVELS }

  validates :text, presence: true, uniqueness: true, allow_blank: false

  # answer1 keeps correct answer
  validates :answer1, :answer2, :answer3, :answer4, presence: true
end
