class Card
  class Civil
    class Wonder
      class PierwszyLotWKosmos < Wonder
        def stages; [3,4,9]; end
        
        # Natychmiast otrzymujesz 1 [culture] za każdy poziom każdej wystawionej przez Ciebie karty technologii.
        def after_build(gc)
          super

          points = gc.player.player_cards(Card::Civil::Technology).sum do |m|
            m.card.age
          end

          gc.player.score_culture(points)
        end
      end
    end
  end
end