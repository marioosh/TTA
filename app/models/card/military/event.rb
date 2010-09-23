class Card
  class Military
    class Event < Military
      def available_actions(type, phase, gc = nil)
        options = super
        options[:play] = PlayerAction::Political::PlayEvent if type == GameCard::PlayerHand && phase == Game::Civilization::Phase::POLITICAL_ACTION
        return options
      end
    end
  end
end
