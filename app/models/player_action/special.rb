class PlayerAction
  class Special < PlayerAction
    def process!
    end

    # Poświęcenie jednostki.
    class SacrificeUnit < Special
      def process!
        super

        raise Game::Error::InvalidAction, "Nie masz żadnej jednostki tego typu." if self.game_card.yellow_tokens < 1

        self.game_card.yellow_tokens -= 1
        self.game_card.save

        # TODO: dodaj do tymczasowej sily cywilizacji
        return false
      end
    end

    # Użycie do obrony
    class PlayDefense < Political
      def process!
        super

        # TODO: dodaj do tymczasowej sily cywilizacji
        self.game_card.discard!
        return false
      end
    end

    # Użycie do kolonizacji
    class PlayColonization < Political
      def process!
        super

        # TODO: dodaj do tymczasowej sily cywilizacji
        self.game_card.discard!
        return false
      end
    end
  end
end