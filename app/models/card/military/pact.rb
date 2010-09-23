class Card
  class Military
    class Pact < Military
      def available_actions(type, phase, gc = nil)
        options = super
        options[:play] = PlayerAction::Political::PlayPact if type == GameCard::PlayerHand && phase == Game::Civilization::Phase::POLITICAL_ACTION
        options[:discard] = PlayerAction::Political::DiscardPact if type == GameCard::PlayerCard && phase == Game::Civilization::Phase::POLITICAL_ACTION
        return options
      end
    end
  end
end