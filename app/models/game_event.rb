class GameEvent < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  def color
    if self.user && self.game
      if player = self.game.is_player?(self.user)
        return player.color
      end
    end
  end
end