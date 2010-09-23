class Card
  class Civil
    class Wonder
      class Hollywood < Wonder
        def stages; [5,6,5]; end
        
        # Natychmiast otrzymujesz 2 [culture] za każdy poziom każdego z Twoich zbudowanych teatrów [theatre] i bibliotek [library].
        def after_build(gc)
          super

          points = gc.player.player_cards(Card::Civil::Technology::Urban::Theatre).sum do |m|
            m.card.age * m.yellow_tokens
          end

          points += gc.player.player_cards(Card::Civil::Technology::Urban::Library).sum do |m|
            m.card.age * m.yellow_tokens
          end

          gc.player.score_culture(points)
        end
      end
    end
  end
end