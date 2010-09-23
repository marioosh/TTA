class Card
  class Military
    class Aggression < Military
      def available_actions(type, phase, gc = nil)
        options = super
        options[:play] = PlayerAction::Political::PlayAggression if type == GameCard::PlayerHand && phase == Game::Civilization::Phase::POLITICAL_ACTION
        return options
      end
      
      class Rozbiory < Aggression
        # TODO: Zabierz przeciwnikowi tyle żółtych znaczników z banku ile wynosi poziom Twojego ustroju i tyle niebieskich znaczników ile wynosi poziom jego ustroju. Dołóż znaczniki do swoich banków.
      end

      class Aneksja < Aggression
      end

      class Grabiez < Aggression
      end

      class Najazd < Aggression
      end

      class Sabotaz < Aggression
      end

      class Skrytobojstwo < Aggression
      end

      class Szpieg < Aggression
      end

      class Zniewolenie < Aggression
      end

      class ZbrojnaInterwencja < Aggression
      end
    end
  end
end
