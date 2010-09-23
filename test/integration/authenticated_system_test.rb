require File.dirname(__FILE__) + '/../test_helper'

class AuthenticatedSystemTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "login and browse" do
    get_via_redirect "/login"
    assert_response :success

    post_via_redirect "/site/security/login", :user => { :login => 'admin@example.com', :password => 'test', :remember_me => '1' }
    assert_equal users(:admin).id, session[:user_id]
    assert_equal users(:admin), @controller.current_user
    assert_response :success

    get "/admin"
    assert_response :success
    assert_equal '/admin', path
  end

  test "login and logout" do
    post "/site/security/login", 'user[login]' => users(:admin).login, 'user[password]' => 'test'
    assert_equal users(:admin), @controller.current_user
    assert_response :redirect

    post_via_redirect "/site/security/logout"
    assert_equal nil, @controller.current_user
    assert_response :success
  end
end
