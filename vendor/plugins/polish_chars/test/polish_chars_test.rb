require File.dirname(__FILE__) + '/../../../../test/test_helper'

class PolishCharsTest < ActiveSupport::TestCase
  test "to_ascii" do
    assert_equal 'Tescie', 'Teście'.to_ascii
  end
end
