require 'test_helper'

class QuestionControllerTest < ActionDispatch::IntegrationTest
  test 'new' do
    post '/questions', params: {question: 'meaning of life', answer: '42'}
    question = Question.last
    assert_equal 'meaning of life', question.question.display
  end

  test 'update question' do
    question = Question.new(question: Text.build_text('what is [1]'))
    question.save!

    patch "/questions/#{question.id}", params: {question: 'what is [2]', answer: '2'}
    question.reload
    assert_equal 'what is [2]', question.question.display
    assert_equal '2', question.answer.display
  end

  test 'idempotent' do
    question = Question.new(question: Text.build_text('what is [1]'),
                            answer: Text.build_text('2'))
    question.save!

    assert_difference(-> {Text.count}, 0) do
      patch "/questions/#{question.id}", params: {question: 'what is [1]', answer: '2'}
      question.reload
      assert_equal 'what is [1]', question.question.display
      assert_equal '2', question.answer.display
    end
  end
end
