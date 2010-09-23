class GameCard < ActiveRecord::Base
  belongs_to :game
  belongs_to :card
  belongs_to :player

  def menu_options
    options = []
    actions = self.card.available_actions(self.class, self.game.phase, self)
    actions.each_pair do |action, description|
      options << [description.to_s, "/game/cards/#{action}/#{self.id}" ]
    end

    return options
  end

  def is_action_available?(action)
    actions = self.card.available_actions(self.class, self.game.phase)
    return !actions[action.to_sym].nil?
  end

  def action!(action, player)
    actions = self.card.available_actions(self.class, self.game.phase)
    actions[action.to_sym].create(:round => self.game.round, :game_card => self, :player => player) unless actions[action.to_sym].nil?
  end
  
  def discard!
    self.type = GameCard::DiscardPile.to_s
    self.active = false
    self.player = nil
    self.save
  end
end