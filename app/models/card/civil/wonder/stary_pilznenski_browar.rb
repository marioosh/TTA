class Card
  class Civil
    class Wonder
      class StaryPilznenskiBrowar < Wonder
        def stages; [5,4,3]; end
        def strength(gc); 2; end
        def science_scoring(gc); 1; end

        # Każda z twoich farm produkuje [culture]: z poziomu A i I - 1 [culture], z poziomu II i III - 2 [culture].
        def culture_scoring(gc)
          gc.player.player_cards(Card::Civil::Technology::Farm).sum do |m|
            m.yellow_tokens * (m.card.age < 2 ? 1 : 2)
          end
        end
      end
    end
  end
end