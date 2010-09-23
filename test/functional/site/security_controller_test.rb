require File.dirname(__FILE__) + '/../../test_helper'

class Site::SecurityControllerTest < ActionController::TestCase
  fixtures :all
  
  test "login" do
    post :login, :user => { :login => 'admin@example.com', :password => 'test', :remember_me => '1' }
    assert_equal users(:admin).id, session[:user_id]
    assert_equal users(:admin), @controller.current_user
    assert_equal users(:admin).remember_token, cookies["auth_token"]
    assert_response :redirect
  end

  test "logout" do
    post :login, :user => { :login => 'admin@example.com', :password => 'test', :remember_me => '1' }
    assert_equal users(:admin).id, session[:user_id]

    post :logout
    assert_equal nil, session[:user_id]
    assert_response :redirect
  end

  test "cookie" do
    @request.cookies['auth_token'] = users(:admin).remember_token

    get :password
    assert_equal users(:admin).id, session[:user_id]
    assert_response :success
  end
end