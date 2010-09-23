class Card
  class Military
    class Tactics < Military
      def available_actions(type, phase, gc = nil)
        options = super
        options[:play] = PlayerAction::Military::PlayTactics if type == GameCard::PlayerHand && phase == Game::Civilization::Phase::ACTIONS
        return options
      end

      def required_types
        self.required_units.map do |type|
          eval("Card::Civil::Technology::Unit::#{type.to_s.camelcase}")
        end
      end

      # TODO: define sets of GameCards involved into each copy of tactics.
      def units(gc)
        used = {}
        units = []
        
        self.required_types.each do |type|
          # TODO: sort by pc.card.age DESC
          gc.player.player_cards(type).each do |pc|
            if pc.yellow_tokens - used[pc.id].to_i > 0
              
            end
          end
        end
      end

      def strength(gc)
        raise ArgumentError, "gc has to be a GameCard" unless gc.is_a?(GameCard)

        # TODO: calculate!
      end

      class Husaria < Tactics
        def required_units; [:artillery, :cavalry, :cavalry]; end
        def strength_value; 7; end
      end

      class OddzialZbrojny < Tactics
        def required_units; [:infrantry, :infrantry]; end
        def strength_value; 1; end
      end

      class Legion < Tactics
        def required_units; [:infrantry, :infrantry, :infrantry]; end
        def strength_value; 2; end
      end

      class Falanga < Tactics
        def required_units; [:infrantry, :infrantry, :cavalry]; end
        def strength_value; 3; end
      end

      class LekkaKawaleria < Tactics
        def required_units; [:cavalry, :cavalry]; end
        def strength_value; 2; end
      end

      class CiezkaKawaleria < Tactics
        def required_units; [:cavalry, :cavalry, :cavalry]; end
        def strength_value; 4; end
      end

      class ArmiaSredniowieczna < Tactics
        def required_units; [:infrantry, :cavalry]; end
        def strength_value; 2; end
      end

      class ArmiaNapoleonska < Tactics
        def required_units; [:infrantry, :cavalry, :artillery]; end
        def strength_value; 8; end
      end

      class ArmiaObronna < Tactics
        def required_units; [:infrantry, :infrantry, :artillery]; end
        def strength_value; 6; end
      end

      class Konkwistatorzy < Tactics
        def required_units; [:infrantry, :cavalry, :cavalry]; end
        def strength_value; 4; end
      end

      class Fortyfikacje < Tactics
        def required_units; [:artillery, :artillery]; end
        def strength_value; 4; end
      end

      class KlasycznaArmia < Tactics
        def required_units; [:infrantry, :cavalry, :infrantry, :cavalry]; end
        def strength_value; 9; end
      end

      class MobilnaArtyleria < Tactics
        def required_units; [:artillery, :artillery]; end
        def strength_value; 5; end
      end

      class Okopy < Tactics
        def required_units; [:artillery, :artillery, :infrantry]; end
        def strength_value; 9; end
      end

      class NowoczesnaArmia < Tactics
        def required_units; [:infrantry, :infrantry, :cavalry, :artillery]; end
        def strength_value; 13; end
      end

      class ArmiaZmechanizowana < Tactics
        def required_units; [:artillery, :artillery, :cavalry]; end
        def strength_value; 10; end
      end

      class OddzialySzturmowe < Tactics
        def required_units; [:infrantry, :cavalry, :cavalry, :cavalry]; end
        def strength_value; 11; end
      end
    end
  end
end