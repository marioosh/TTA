class PlayerAction
  class Political < PlayerAction
    def process!
      raise Game::Error::InvalidAction, "Nie masz wystarczającej liczby akcji militarnych (potrzeba #{self.cost_actions})." if self.cost_actions > self.player.military_actions_left
      self.actions = self.cost_actions
      self.save
    end

    def cost_actions
      return 0
    end

    class PlayEvent < Political
      def process!
        super

        self.game_card.player.score_culture(self.game_card.card.age)
        
        self.game_card.type = GameCard::FutureEvent.to_s
        self.game_card.player = nil
        self.game_card.save

        # TODO: odkryj kolejna karte z decku GameCard::CurrentEvent
        #       i stworz z niej akcje
      end
    end

    class PlayPact < Political
      def process!
        super
      end
    end

    class PlayAggression < Political
      def cost_actions
        # TODO: from card
        return 2
      end

      def process!
        super
      end
    end

    class DeclareWar < Political
      def cost_actions
        # TODO: from card
        return 2
      end

      def process!
        super
      end
    end

    class DiscardPact < Political
      def process!
        super
      end
    end
  end
end