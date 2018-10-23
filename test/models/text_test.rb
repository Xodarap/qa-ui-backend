require 'test_helper'

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
end
 