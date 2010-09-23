class Card
  class Military
    class War < Military
      def available_actions(type, phase, gc = nil)
        options = super
        options[:play] = PlayerAction::Political::DeclareWar if type == GameCard::PlayerHand && phase == Game::Civilization::Phase::POLITICAL_ACTION
        return options
      end

      class WojnaOZiemie < War
      end

      class WojnaOWiedze < War
      end

      class WojnaOKulture < War
      end

      class WojnaOZasoby < War
      end

      class SwietaWojna < War
      end
    end
  end
end
