class Card
  class Civil
    class Wonder
      class WielkiMur < Wonder
        def stages; [2, 2, 3, 2]; end
        def culture_scoring(gc); 1; end
        def happiness(gc); 1; end
        def happy_faces; 1; end
        def strength(gc)
          strength = gc.player.player_cards(Card::Civil::Technology::Unit::Infrantry).sum { |c| c.yellow_tokens }
          strength + gc.player.player_cards(Card::Civil::Technology::Unit::Artillery).sum { |c| c.yellow_tokens }
        end
      end
    end
  end
end