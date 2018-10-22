class Question < ApplicationRecord
	belongs_to :parent, class_name: 'Question', optional: true
	has_many :children, class_name: 'Question', foreign_key: 'parent_id'
end
