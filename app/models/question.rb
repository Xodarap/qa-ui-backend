class Question < ApplicationRecord
  belongs_to :parent, class_name: 'Question', optional: true
  has_many :children, class_name: 'Question', foreign_key: 'parent_id'

  belongs_to :question, class_name: 'Text'
  belongs_to :answer, class_name: 'Text', optional: true

  def as_json
    question.assign_counters
    answer&.assign_counters
    {
      question: question.as_json,
      answer: answer&.as_json,
      parent_id: parent_id,
      children: children.map(&:as_json),
      id: id
    }
  end
end
