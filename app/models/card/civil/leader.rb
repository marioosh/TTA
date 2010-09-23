class Card
  class Civil
    class Leader < Civil

      def available_actions(type, phase, gc = nil)
        options = super
        options[:play] = PlayerAction::Civil::PlayLeader if type == GameCard::PlayerHand && phase == Game::Civilization::Phase::ACTIONS
        return options
      end

      class Hammurabi < Leader; end
      class JuliuszCezar < Leader; end
      class CzyngisChan < Leader; end
      class KrzysztofKolumn < Leader; end
      class LeonardoDaVinci < Leader; end
      class MichalAniol < Leader; end
      class JoannaDArc < Leader; end
      class WilliamSzekspir < Leader; end
      class NapoleonBonaparte < Leader; end
      class IsaacNewton < Leader; end
      class PraojciecCzech < Leader; end
      class JanZizka < Leader; end
      class JanAmosKomensky < Leader; end
      class TomasGarrigueMasaryk < Leader; end
      class MaksymilianRobespierre < Leader; end
      class JamesCook < Leader; end
      class JanSebastianBach < Leader; end
      class MahatmaGandhi < Leader; end
      class BillGates < Leader; end
      class SidMeier < Leader; end
      class WinstonChurchill < Leader; end
      class AlbertEinstein < Leader; end
      class ElvisPresley < Leader; end

      class FryderykIBarbarossa < Leader
        def available_actions(type, phase)
          options = super
          options[:special] = PlayerAction::Civil::Special if type == GameCard::PlayerCard && phase == Game::Civilization::Phase::ACTIONS
          return options
        end
      end

      class AleksanderMacedonski < Leader
        # Każda z Twoich jednostek militarnych daje Ci +1 siły.
        def strength(gc)
          raise ArgumentError, "gc has to be a GameCard" unless gc.is_a?(GameCard)
          gc.player.player_cards(Card::Civil::Technology::Unit).sum { |c| c.yellow_tokens }
        end
      end

      class Arystoteles < Leader
        # TODO: Za każdym razem gdy bierzesz kartę technologii z toru kart, dodajesz sobie 1 [science].
        def take_card(gc, card)

        end
      end

      class Mojzesz < Leader
        # TODO: Zwiększanie populacji kosztuje Cię 1 [food] mniej.
        def increase_population(gc)

        end
      end

      class Homer < Leader
        # TODO: W każdej rundzie masz dodatkowy 1 [resource] na budowę jednostek militarnych.
        def build_unit(gc)

        end

        # Do dwóch z Twoich Wojowników produkuje po 1 [culture] każdy.
        def culture_scoring(gc)
          raise ArgumentError, "gc has to be a GameCard" unless gc.is_a?(GameCard)
          [gc.player.player_cards(Card::Civil::Technology::Unit::Infrantry, 'cards.age' => '0').first.yellow_tokens, 2].min
        end
      end

      class MikolajKopernik < Leader
        # TODO: Twoja najlepsza świątynia [temple] lub biblioteka [library] produkuje dodatkowo tyle nauki ile wynosi poziom tego budynku. Za każdym razem gdy zagrywasz kartę specjalnej (niebieskiej) technologii otrzymujesz 1 [science] i 1 [resource].
      end

      class JanPawelII < Leader
        # TODO: Każda z Twoich świątyń [temple] produkuje tyle [culture] ile wynosi poziom budynku. Twój ustrój produkuje tyle [culture] ile wynosi jego poziom.
      end
    end
  end
end
