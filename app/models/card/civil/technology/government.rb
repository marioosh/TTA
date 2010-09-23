class Card
  class Civil
    class Technology
      class Government < Technology
        def available_actions(type, phase, gc = nil)
          options = super
          options[:revolution] = PlayerAction::Civil::StartRevolution if type == GameCard::PlayerHand && phase == Game::Civilization::Phase::ACTIONS
          options[:population] = PlayerAction::Civil::IncreasePopulation if type == GameCard::PlayerCard && phase == Game::Civilization::Phase::ACTIONS
          return options
        end
      end
    end
  end
end