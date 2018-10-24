require 'test_helper'
require 'text'

class TextTest < ActiveSupport::TestCase
  test 'parses simple' do 
    assert_equal 'some simple text', Text.build_text('some simple text').display
  end

  test 'one pointer' do
    assert_equal '[pointer]', Text.build_text('[pointer]').display
  end

  test 'text with pointer' do
    assert_equal 'what is the sum of [1 [2 [3]]]?', 
      Text.build_text('what is the sum of [1 [2 [3]]]?').display
  end

  test 'complicated nesting' do
    assert_equal 'before [1st [2nd]] [3rd]',
      Text.build_text('before [1st [2nd]] [3rd]').display
  end

  test 'hidden pointers' do
    [['what is the sum of [1 [2 [3]]]?', 'what is the sum of #1?'],
    ['a [b [c]] d [e [f [g]]] h', 'a #1 d #2 h']].each do |input, expected|
      text = Text.build_text(input)
      text.assign_counters
      assert_equal expected, text.display(false)
    end
  end

  test 'some expanded pointers' do
    text = Text.build_text('a [b [c]] d [e]')
    text.children[1].expanded = true
    text.assign_counters

    assert_equal 'a [b #1] d #2', text.display(false)
  end

  test 'identifies pointers' do
    text = Text.build_text('a [b [c]] d [e [f [g]]]')
    text.children[1].expanded = true
    text.assign_counters
    child = text.find_pointer(1)
    second = text.find_pointer(2)

    assert_equal '[c]', child.display
    assert_equal '[e [f [g]]]', second.display
  end
end
 