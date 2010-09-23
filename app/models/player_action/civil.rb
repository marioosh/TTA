class PlayerAction
  class Civil < PlayerAction
    def process!
      if self.cost_actions > 0
        raise Game::Error::InvalidAction, "Nie masz wystarczającej liczby akcji cywilnych (potrzeba #{self.cost_actions})." if self.cost_actions > self.player.civil_actions_left
        self.actions = self.cost_actions
        self.save
      end

      if self.respond_to?(:cost_resources)
        raise Game::Error::InvalidAction, "Wymagane #{self.cost_resources} surowców." if self.cost_resources > self.player.available_resources
        self.player.pay_resources(self.cost_resources)
      end

      if self.respond_to?(:cost_food)
        raise Game::Error::InvalidAction, "Wymagane #{self.cost_food} żywności." if self.cost_food > self.player.available_food
        self.player.pay_food(self.cost_food)
      end

      # TODO: another cards callbacks for paying science (discounts, etc.)!
      if self.respond_to?(:cost_science)
        raise Game::Error::InvalidAction, "Wymagane #{self.cost_science} pkt nauki." if self.cost_science > self.player.points_science
        self.player.pay_science(self.cost_science)
      end
    end

    def cost_actions
      return 1
    end

    # Wzięcie karty (za 1, 2 lub 3 akcje cywilne) - zapłać 1 akcję więcej za każdy zbudowany cud, jeżeli bierzesz z toru kolejny cud.
    class TakeCard < Civil
      def cost_actions
        # ZUŻYJ 1, 2 lub 3 AKCJE CYWILNE
        cost = case self.game_card.position
        when 0..4 then 1
        when 5..8 then 2
        when 9..12 then 3
        end

        # TODO: cuda taniej z Michalem Aniolem
        # Zapłać 1 akcję więcej za każdy zbudowany cud, jeżeli bierzesz z toru kolejny cud.
        cost += self.player.player_cards(Card::Civil::Wonder).length if self.player && self.game_card.card.is_a?(Card::Civil::Wonder)
        return cost
      end

      def process!
        super

        self.player.player_cards.each do |gc|
          # NIE WOLNO CI DOBIERAĆ TECHNOLOGII, JEŚLI MASZ JUŻ TAKĄ SAMĄ KARTĘ NA RĘKU LUB NA STOLE.
          raise Game::Error::InvalidAction, "Nie możesz wziąć kolejnej karty tego samego rodzaju." if self.game_card.card.is_a?(Card::Civil::Technology) && gc.card.is_a?(Card::Civil::Technology) && gc.card.name == self.game_card.card.name

          # Z KAŻDEJ EPOKI MOŻESZ WZIĄĆ TYLKO JEDNEGO LIDERA.
          raise Game::Error::InvalidAction, "Nie możesz wziąć kolejnego lidera z epoki #{self.game_card.card.age_to_s}." if self.game_card.card.is_a?(Card::Civil::Leader) && gc.card.is_a?(Card::Civil::Leader) && gc.card.age == self.game_card.card.age
        end

        self.player_hand.each do |gc|
          # NIE WOLNO CI DOBIERAĆ TECHNOLOGII, JEŚLI MASZ JUŻ TAKĄ SAMĄ KARTĘ NA RĘKU LUB NA STOLE.
          raise Game::Error::InvalidAction, "Nie możesz wziąć kolejnej karty tego samego rodzaju." if self.game_card.card.is_a?(Card::Civil::Technology) && gc.card.is_a?(Card::Civil::Technology) && gc.card.name == self.game_card.card.name

          # Z KAŻDEJ EPOKI MOŻESZ WZIĄĆ TYLKO JEDNEGO LIDERA.
          raise Game::Error::InvalidAction, "Nie możesz wziąć kolejnego lidera z epoki #{self.game_card.card.age_to_s}." if self.game_card.card.is_a?(Card::Civil::Leader) && gc.card.is_a?(Card::Civil::Leader) && gc.card.age == self.game_card.card.age
        end

        if self.game_card.card.is_a?(Card::Civil::Wonder)
          # MOŻESZ POSIADAĆ TYLKO JEDEN CUD „W TRAKCIE BUDOWY”. NIE WOLNO CI DOBIERAĆ KOLEJNYCH KART CUDÓW, DOPÓKI NIE SKOŃCZYSZ GO BUDOWAĆ.
          raise Game::Error::InvalidAction, "Nie możesz posiadać więcej niż 1 cudu w budowie." if self.player.player_wonder
        else
          raise Game::Error::InvalidAction, "Nie możesz przekroczyć limitu kart cywilnych w ręku (#{self.player.max_civil_cards})." if self.player.max_civil_cards <= self.player.player_hand(Card::Civil).length
        end

        self.game_card.type = self.game_card.card.is_a?(Card::Civil::Wonder) ? GameCard::PlayerWonder.to_s : GameCard::PlayerHand.to_s
        self.game_card.player = self.player
        self.game_card.save
      end
    end

    # Zwiększenie populacji.
    class IncreasePopulation < Civil
      def cost_food
        self.player.population_cost
      end

      def process!
        super
        self.player.increase_population
      end
    end

    # Budowa budynku, farmy lub kopalni.
    class Build < Civil
      class Building < Build; end
      class Mine < Build; end
      class Farm < Build; end
      
      def cost_resources
        self.game_card.card.cost_resources
      end

      def process!
        super

        # TODO: SPRAWDŹ, CZY NIE WYKORZYSTAŁEŚ JUŻ LIMITU DLA DANEGO TYPU BUDYNKÓW
        # NARZUCONEGO PRZEZ POSIADANY USTRÓJ. -- tylko dla budynkow publicznych

        # SPRAWDŹ CZY MASZ WOLNYCH ROBOTNIKÓW
        raise Game::Error::InvalidAction, "Nie masz wolnego robotnika." if self.player.free_workers < 1

        # WYBUDUJ BUDYNEK PUBLICZNY.
        self.game_card.yellow_tokens += 1
        self.game_card.save

        # PRZEMIEŚĆ 1 ŻÓŁTY ZNACZNIK Z POLA WOLNYCH
        # ROBOTNIKÓW NA SZARĄ KARTĘ BUDYNKU PUBLICZNEGO
        self.player.free_workers -= 1
        self.player.save
      end
    end


    # Ulepszenie budynku, farmy lub kopalni.
    class Upgrade < Civil
      class Building < Upgrade; end
      class Mine < Upgrade; end
      class Farm < Upgrade; end

      def process!
        super
      end
    end

    # Zniszczenie budynku, farmy lub kopalni.
    class Destroy < Civil
      class Building < Destroy; end
      class Mine < Destroy; end
      class Farm < Destroy; end

      def process!
        super
        raise Game::Error::InvalidAction, "Nie masz żadnego budynku tego typu." if self.game_card.yellow_tokens < 1

        self.game_card.yellow_tokens -= 1
        self.game_card.save

        self.player.free_workers += 1
        self.player.save
      end
    end

    # Budowa etapu cudu świata.
    class BuildWonder < Civil
      def cost_resources
        self.game_card.card.cost_resources(self.game_card)
      end

      def process!
        super
        
        # WYBUDUJ STADIUM CUDU
        self.game_card.blue_tokens += 1
        self.game_card.save

        # KIEDY WYBUDUJESZ OSTATNIE STADIUM CUDU...
        if self.game_card.blue_tokens == self.game_card.card.stages.length
          # ZWRÓĆ WSZYSTKIE NIEBIESKIE ZNACZNIKI Z KARTY CUDU DO NIEBIESKIEGO BANKU.
          self.game_card.blue_tokens = 0

          # POŁÓŻ KARTĘ CUDU PIONOWO NAD PLANSZĄ CYWILIZACJI.
          self.game_card.type = GameCard::PlayerCard.to_s
          self.game_card.save

          # TODO: WPROWADŹ DO GRY SPECJALNE ZDOLNOŚCI CUDU, JEŚLI TAKIE POSIADA.
          self.game_card.card.after_build(self.game_card)
        end
      end
    end

    # Wprowadzenie lidera do gry.
    class PlayLeader < Civil
      def process!
        super
        
        # WYŁÓŻ KARTĘ LIDERA OBOK TWOJEJ PLANSZY CYWILIZACJI
        self.player.leader = self.game_card

        # ZUŻYJ 1 AKCJĘ CYWILNĄ
        self.actions = 1
        self.save

        # TODO: Kiedy znacznik tracisz akcji,
        #       możesz odrzucić już ten zużyty w tej turze.
      end
    end

    # Zagranie karty technologii.
    class PlayTechnology < Civil
      def cost_science
        self.game_card.card.cost_science
      end

      def process!
        super
        
        # TODO: speciale powinny discardowac swoje poprzednie wersje
        if self.game_card.card.is_a?(Card::Civil::Technology::Government)
          self.player.government = self.game_card
        else
          self.game_card.type = GameCard::PlayerCard.to_s
          self.game_card.player = self.player
          self.game_card.save
        end
      end
    end

    # Rozpoczęcie rewolucji.
    class StartRevolution < Civil
      def cost_actions
        # ZUŻYJ WSZYSTKIE AKCJE CYWILNE
        self.player.max_civil_actions
      end

      def cost_science
        self.game_card.card.cost_revolution
      end

      def process!
        super
        
        # MUSI TO BYĆ PIERWSZA I JEDYNA AKCJA CYWILNA W TWOJEJ TURZE
        raise Game::Error::InvalidAction, "Rewolucja musi być pierwszą akcją cywilną w turze." if self.player.used_civil_actions > 0

        self.player.government = self.game_card
      end
    end

    # Zagranie karty akcji (nie wolno zagrać karty wziętej z toru w tej rundzie).
    class PlayAction < Civil
      def process!
        super
        
        # TODO: do actual action
        self.game_card.discard!
      end
    end

    # Akcja specjalna, zalezna od karty
    class Special < Civil
      def process!
        super
      end
    end
  end
end