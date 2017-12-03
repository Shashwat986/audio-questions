class Attempt < ApplicationRecord
  belongs_to :user
  has_many :answers

  before_create :add_questions

  # NOTE: attempt_count is one-indexed
  MAX = 5

  def questions
    self.question_ids.split(',').map {|q_id| Question.find_by_id(q_id.to_i)}
  end

  def question_count
    self.question_ids.split(',').count
  end

  def active_question idx = nil
    self.questions[(idx || self.attempt_count) - 1]
  end

  def results
    self.questions.map do |q|
      a = Answer.find_by_auq(self.id, self.user_id, q.id)
      [q, a]
    end
  end

  def set_inactive
    self.active = false
    self.save
  end

  # TODO: Add salt
  def get_hash
    hashids = Hashids.new
    hashids.encode(self.id)
  end

  # TODO: Add salt
  def self.find_by_hash hash
    hashids = Hashids.new
    a_id = hashids.decode(hash)[0]
    return nil if a_id.nil?

    self.find_by_id(a_id)
  end

  private

  def add_questions
    q_ids = Question.all.sample(MAX).map(&:id).map(&:to_s).join(',')
    self.question_ids = q_ids
    self.attempt_count = 0
  end
end
