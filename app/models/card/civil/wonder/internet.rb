class Card
  class Civil
    class Wonder
      class Internet < Wonder
        def stages; [2,3,4,3,2]; end
        
        # Natychmiast otrzymujesz 2 [culture] za każdy poziom każdego z Twoich zbudowanych laboratoriów [lab] i bibliotek [library].
        def after_build(gc)
          super

          points = gc.player.player_cards(Card::Civil::Technology::Urban::Laboratory).sum do |m|
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