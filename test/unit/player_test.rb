require File.dirname(__FILE__) + '/../test_helper'

class PlayerTest < ActiveSupport::TestCase
  fixtures :all
  
  test "produce and pay food" do
    p = players(:quentin_game_1)
    p.game_cards << GameCard::PlayerCard.create(:yellow_tokens => 2, :card => cards(:rolnictwo_22))
    p.game_cards << GameCard::PlayerCard.create(:yellow_tokens => 1, :card => cards(:irygacja_108))
    p.game_cards << GameCard::PlayerCard.create(:yellow_tokens => 0, :card => cards(:zmechanizowane_rolnictwo_117))

    # re-link objects
    farm_agriculture = p.player_cards[0]
    farm_irrigation  = p.player_cards[1]
    farm_mechanized  = p.player_cards[2]
    assert_equal 3, p.player_cards.length

    p.produce_food
    assert_equal 4, p.available_food
    assert_equal 2, farm_agriculture.blue_tokens
    assert_equal 1, farm_irrigation.blue_tokens
    assert_equal 0, farm_mechanized.blue_tokens

    p.produce_food(:amount => 8)
    assert_equal 12, p.available_food
    assert_equal 3, farm_agriculture.blue_tokens
    assert_equal 2, farm_irrigation.blue_tokens
    assert_equal 1, farm_mechanized.blue_tokens

    p.pay_food(4)
    assert_equal 8, p.available_food
    assert_equal 1, farm_agriculture.blue_tokens
    assert_equal 1, farm_irrigation.blue_tokens
    assert_equal 1, farm_mechanized.blue_tokens

    p.pay_food(4)
    assert_equal 4, p.available_food
    assert_equal 0, farm_agriculture.blue_tokens
    assert_equal 2, farm_irrigation.blue_tokens
    assert_equal 0, farm_mechanized.blue_tokens

    assert_raise Player::Error do
      p.pay_food(5)
    end
  end

  test "produce and pay resources" do
    p = players(:quentin_game_1)
    p.game_cards << GameCard::PlayerCard.create(:yellow_tokens => 2, :card => cards(:braz_21))
    p.game_cards << GameCard::PlayerCard.create(:yellow_tokens => 1, :card => cards(:zelazo_105))
    p.game_cards << GameCard::PlayerCard.create(:yellow_tokens => 0, :card => cards(:ropa_115))

    # re-link objects
    mine_bronze = p.player_cards[0]
    mine_iron   = p.player_cards[1]
    mine_oil    = p.player_cards[2]
    assert_equal 3, p.player_cards.length

    p.produce_resources
    assert_equal 4, p.available_resources
    assert_equal 2, mine_bronze.blue_tokens
    assert_equal 1, mine_iron.blue_tokens
    assert_equal 0, mine_oil.blue_tokens

    p.produce_resources
    assert_equal 4, mine_bronze.blue_tokens
    assert_equal 2, mine_iron.blue_tokens
    assert_equal 0, mine_oil.blue_tokens

    p.produce_resources(:amount => 1)
    assert_equal 5, mine_bronze.blue_tokens
    assert_equal 2, mine_iron.blue_tokens
    assert_equal 0, mine_oil.blue_tokens

    p.produce_resources(:amount => 8)
    assert_equal 6, mine_bronze.blue_tokens
    assert_equal 3, mine_iron.blue_tokens
    assert_equal 1, mine_oil.blue_tokens

    # corruption begins!
    assert_equal 2, p.corruption

    p.produce_resources
    assert_equal 6, mine_bronze.blue_tokens
    assert_equal 4, mine_iron.blue_tokens
    assert_equal 1, mine_oil.blue_tokens
    assert_equal 19, p.available_resources

    p.pay_resources(3)
    assert_equal 16, p.available_resources
    assert_equal 3, mine_bronze.blue_tokens
    assert_equal 4, mine_iron.blue_tokens
    assert_equal 1, mine_oil.blue_tokens

    p.pay_resources(8)
    assert_equal 8, p.available_resources
    assert_equal 1, mine_bronze.blue_tokens
    assert_equal 1, mine_iron.blue_tokens
    assert_equal 1, mine_oil.blue_tokens

    p.pay_resources(4)
    assert_equal 4, p.available_resources
    assert_equal 0, mine_bronze.blue_tokens
    assert_equal 2, mine_iron.blue_tokens
    assert_equal 0, mine_oil.blue_tokens

    assert_raise Player::Error do
      p.pay_resources(5)
    end
  end

  test "civil actions left" do
    p1 = players(:quentin_game_3)
    p2 = players(:aaron_game_3)

    # round 0
    assert_equal 1, p1.civil_actions_left
    assert_equal 2, p2.civil_actions_left

    # round 1
    p1.game.round = 1
    assert_equal 0, p1.used_civil_actions

    # use 3 actions to take a card
    action = p1.player_actions.build(:round => p1.game.round, :actions => 3)
    action.type = 'PlayerAction::Civil::Test'
    action.save
    assert_equal 3, p1.used_civil_actions

    action = p1.player_actions.build(:round => p1.game.round, :actions => 1)
    action.type = 'PlayerAction::Civil::Test'
    action.save
    assert_equal 4, p1.used_civil_actions
  end
end
