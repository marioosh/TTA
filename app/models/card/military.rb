class Card
  class Military < Card
    def available_actions(type, phase, gc = nil)
      options = super
      options[:discard] = PlayerAction::Military::DiscardCard if type == GameCard::PlayerHand && phase == Game::Civilization::Phase::DISCARD_EXCESS_MILITARY_CARDS
      options[:take] = PlayerAction::Military::TakeCard if type == GameCard::MilitaryDeck && phase == Game::Civilization::Phase::MAINTENANCE
      return options
    end
  end
end