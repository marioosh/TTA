class PlayerAction
  class Military < PlayerAction
    def process!
      if self.cost_actions > 0
        raise Game::Error::InvalidAction, "Nie masz wystarczającej liczby akcji militarnych (potrzeba #{self.cost_actions})." if self.cost_actions > self.player.military_actions_left
        self.actions = self.cost_actions
        self.save
      end

      if self.respond_to?(:cost_resources)
        raise Game::Error::InvalidAction, "Wymagane #{self.cost_resources} surowców." if self.cost_resources > self.player.available_resources
        self.player.pay_resources(self.cost_resources)
      end
    end

    def cost_actions
      return 1
    end

    # Rekrutacja jednostki wojskowej.
    class BuildUnit < Military
      def cost_resources
        self.game_card.card.cost_resources
      end

      def process!
        super

        # SPRAWDŹ CZY MASZ WOLNYCH ROBOTNIKÓW
       raise Game::Error::InvalidAction, "Nie masz wolnego robotnika." if self.player.free_workers < 1

        # WYBUDUJ JEDNOSTKĘ
        self.game_card.yellow_tokens += 1
        self.game_card.save

        # PRZEMIEŚĆ 1 ŻÓŁTY ZNACZNIK Z POLA WOLNYCH
        # ROBOTNIKÓW NA KARTĘ JEDNOSTKI.
        self.player.free_workers -= 1
        self.player.save
      end
    end

    # Ulepszenie jednostki.
    class UpgradeUnit < Military
    end

    # Rozwiązanie jednostki.
    class DestroyUnit < Military
      def process!
        super

        raise Game::Error::InvalidAction, "Nie masz żadnej jednostki tego typu." if self.game_card.yellow_tokens < 1

        self.game_card.yellow_tokens -= 1
        self.game_card.save

        self.player.free_workers += 1
        self.player.save
      end
    end

    # Zagranie karty taktyki.
    class PlayTactics < Military
      def process!
        super

        # WYŁÓŻ KARTĘ TAKTYKI OBOK TWOJEJ PLANSZY CYWILIZACJI
        self.player.tactics = self.game_card
      end
    end

    # Wzięcie karty na koniec tury.
    class TakeCard < Military
      def process!
        super

        self.game_card.type = GameCard::PlayerHand.to_s
        self.game_card.player = self.player
        self.game_card.save
      end
    end

    # Odrzucenie nadmiaru kart.
    class DiscardCard < Military
      def cost_actions; 0; end
      def process!
        super
        self.game_card.discard!
      end
    end

  end
end