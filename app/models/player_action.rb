class PlayerAction < ActiveRecord::Base
  belongs_to :player
  belongs_to :game_card
  belongs_to :target_card, :class_name => 'GameCard'

  def process!
    raise StandardError, "You are not supposed to run the PlayerAction superclass." if self.class == PlayerAction
    raise Game::Error::InvalidAction, "#{self.class}: NOT IMPLEMENTED!"
  end
end