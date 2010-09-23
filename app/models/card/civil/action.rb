class Card
  class Civil
    class Action < Civil

      def available_actions(type, phase, gc = nil)
        options = super
        options[:play] = PlayerAction::Civil::PlayAction if type == GameCard::PlayerHand && phase == Game::Civilization::Phase::ACTIONS
        return options
      end

      class UrodzajneZiemie < Action
        # TODO: Zbuduj nową kopalnię lub farmę; zapłać o 1 [resource] mniej.
      end

      class IdealneMiejsceNaBudowe < Action
        # TODO: Zbuduj nowy budynek publiczny; zapłać o 1 [resource] mniej.
      end

      class GeniuszKonstruktorski < Action
        # TODO: Zbuduj jeden etap cudu; zapłać o 2 [resource] mniej.
      end

      class DzieloSztuki < Action
        # TODO: Dodaj sobie 6 [culture].
      end

      class RewolucyjnyPomysl < Action
        # TODO: Dodaj sobie 1 [science].
      end

      class Patriotyzm < Action
        # TODO: W tej rundzie masz 1 dodatkową akcję militarną i dodatkowy 1 [resource] na budowanie jednostek militarnych.
      end

      class ZapasyZywnosci < Action
        # TODO: Zwiększ swoją populację za pełną cenę; następnie wyprodukuj 1 [food].
      end

      class ZlozaMineralow < Action
        # TODO: Twoja cywilizacja produkuje 4 surowce.
      end

      class SzybkaModernizacja < Action
        # TODO: Ulepsz farmę, kopalnię lub budynek publiczny; zapłać o 4 surowce mniej.
      end

      class PrzelomTechnologiczny < Action
        # TODO: Zagraj kartę technologii za pełną cenę; następnie dodaj sobie 2 nauki.
      end

      class UdaneZbiory < Action
        # TODO: Twoja cywilizacja produkuje 2 żywności.
      end

      class FalaNacjonalizmu < Action

      end

      class MecenatSztuki < Action

      end

      class Zbrojenia < Action

      end
    end
  end
end
