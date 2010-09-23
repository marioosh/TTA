class Card
  class Civil
    class Technology < Civil
      def available_actions(type, phase, gc = nil)
        options = super
        options[:play] = PlayerAction::Civil::PlayTechnology if type == GameCard::PlayerHand && phase == Game::Civilization::Phase::ACTIONS
        return options
      end
    end
  end
end
