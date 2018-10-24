require 'test_helper'
require 'json'

class TextsControllerTest < ActionDispatch::IntegrationTest
  test 'expandPointer' do
    text = Text.build_text('what is the sum of [1 [2 [3]]]?')
    text.save!
    post '/texts/expand_pointer', params: {id: text.id, number: 1}
    parsed = JSON.parse(@response.body)
    assert_equal 'what is the sum of [1 #1]?', parsed['display_collapsed']
  end
end
