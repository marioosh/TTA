require File.dirname(__FILE__) + '/../test_helper'

class RoutingTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "site" do
    assert_routing '/', { :controller => "site/games", :action => "index" }
    assert_routing '/admin', { :controller => "admin/index", :action => "index" }
    assert_routing '/game/5', { :controller => "game/index", :action => "index", :id => "5" }
  end
end
