class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :attempt
  belongs_to :user

  def self.find_by_auq attempt_id, user_id, question_id
    self.where(
      attempt_id: attempt_id,
      user_id: user_id,
      question_id: question_id
    ).first
  end
end
