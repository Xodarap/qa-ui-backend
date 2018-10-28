require 'test_helper'
require 'json'

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

  test 'show' do
    question = Question.new(question: Text.build_text('meaning of life'))
    question.save!

    get "/questions/#{question.id}"
    assert_equal 'meaning of life', JSON.parse(response.body)['question']['display_expanded']
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

  test 'destroy' do
    question = Question.new(question: Text.build_text('what is [1]'),
                            answer: Text.build_text('2'))
    question.save!
    Question.new(question: Text.build_text('child'), parent: question).save!
    
    assert_difference(-> {Question.count}, -2) do
      delete "/questions/#{question.id}"
    end
  end

  test 'options' do
    #todo: not sure how to test the options verb
    #options '/questions'
    #assert_equal '*', response.headers['Access-Control-Allow-Origin']
  end
end
