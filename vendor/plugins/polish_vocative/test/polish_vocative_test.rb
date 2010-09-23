require File.dirname(__FILE__) + '/../../../../test/test_helper'

class PolishVocativeTest < ActiveSupport::TestCase
  test "vocative" do
    assert_equal 'Teście', 'Test'.vocative
    assert_equal 'Kasiu Kowalska', 'Kasia Kowalska'.vocative
    assert_equal 'Krzysiu', 'Krzyś'.vocative
  end
end
