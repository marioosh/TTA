class Card
  class Military
    class Bonus < Military
      def available_actions(type, phase, gc = nil)
        options = super
         options[:play] = PlayerAction::Special::PlayDefense if type == GameCard::PlayerHand && phase == Game::Civilization::Phase::AGGRESSION_DEFEND
         options[:play] = PlayerAction::Special::PlayDefense if type == GameCard::PlayerHand && phase == Game::Civilization::Phase::WAR_DEFEND
         options[:play] = PlayerAction::Special::PlayColonization if type == GameCard::PlayerHand && phase == Game::Civilization::Phase::COLONIZATION_PAY
        return options
      end
    end
  end
end