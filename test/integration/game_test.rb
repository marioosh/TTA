require File.dirname(__FILE__) + '/../test_helper'

class GameTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "anonymous acccess" do
    get game_url(:id => games(:game_1_waiting_ranking_no_password))
    assert_response :redirect

    get game_url(:id => games(:game_2_waiting_ranking_password))
    assert_response :redirect

    get game_url(:id => games(:game_3_in_progress_not_ranked_no_password))
    assert_response :success

    get "/site/games/create"
    assert_response :redirect
  end

  test "login and join the game" do
    quentin = login(:quentin)
    aaron = login(:aaron)

    quentin.get "/site/games/create"
    assert_response :success

    # quentin posts to create a game with password
    # - all settings match?
    # - is quentin a player?
    # - is this site/games/setup?
    # aaron joins without password
    # - failed?
    # aaron joins with password
    # - is aaron a player?
  end

private

  def login(user)
    open_session do |s|
      u = users(user) if user.is_a?(Symbol)

      s.post_via_redirect "/site/security/login", 'user[login]' => u.login, 'user[password]' => 'test'
      assert_response :success
      assert_equal users(:admin).id, s.session[:user_id]
    end
  end
end
