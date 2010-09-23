class Card
  class Civil < Card
    def available_actions(type, phase, gc = nil)
      options = super
      options[:take] = PlayerAction::Civil::TakeCard if type == GameCard::CardRow && phase == Game::Civilization::Phase::ACTIONS
      return options
    end
  end
end