require File.dirname(__FILE__) + '/../test_helper'

class GameTest < ActiveSupport::TestCase
  fixtures :games, :players, :users

  test "lock version" do
    g1 = Game.find(games(:game_1_waiting_ranking_no_password).id)
    g2 = Game.find(games(:game_1_waiting_ranking_no_password).id)

    g1.round = 1
    g2.round = 2

    g1.save
    assert_raise(ActiveRecord::StaleObjectError) { g2.save }
  end

  test "start game" do
    # brak graczy, nie powinna wystartować
    g = create_game(users(:quentin))
    assert_raise(Game::Error::NotEnoughPlayers) { g.start_game }

    # za mało graczy, nie powinna wystartować
    player_1 = g.join_player(users(:quentin))
    assert_raise(Game::Error::NotEnoughPlayers) { g.start_game }

    # wszyscy gracze powinni mieć określone kolory
    player_2 = g.join_player(users(:aaron))
    assert_raise(Game::Error) { g.start_game }

    # nie mozna wybrac tego samego koloru dwa razy
    assert_raise(Player::Error::InvalidColor) do
      player_1.color = Player::Color::RED
      player_1.save
      player_2.color = Player::Color::RED
      player_2.save
    end

    # teraz powinno wystartować
    player_2.color = Player::Color::GREEN
    assert g.start_game.is_a?(Game)
    assert g.status == Game::Status::IN_PROGRESS

    # rozgrywka z fixtur tez powinna wystartowac
    g = games(:game_1_waiting_ranking_no_password)
    assert g.start_game.is_a?(Game)
    assert g.status == Game::Status::IN_PROGRESS
  end

  test "reset game" do
    g = games(:game_3_in_progress_not_ranked_no_password)
    assert g.reset_game
    assert g.game_cards.empty?
    assert g.status == Game::Status::WAITING_FOR_PLAYERS
    assert g.current_player.nil?
    assert g.active_player.nil?
    assert g.round.zero?
    assert g.phase.nil?
    assert g.age.zero?
  end

  test "main loop" do
    g = games(:game_3_in_progress_not_ranked_no_password)
  end

  test "join player" do
    g = games(:game_1_waiting_ranking_no_password)
    assert g.is_player?(users(:quentin))
    assert g.is_player?(users(:aaron))
    assert !g.is_player?(users(:admin))

    # juz jest graczem
    assert g.join_player(users(:quentin)).nil?

    # za duzo graczy
    g.max_players = 2
    assert_raise(Game::Error::TooManyPlayers) { g.join_player(users(:admin)) }

    # ... teraz w sam raz
    g.max_players = 3
    assert g.join_player(users(:admin)).is_a?(Player)
  end

protected
  def create_game(user, options = {})
    record = Game.new({ :user => user }.merge(options))
    record.save
    record
  end
end