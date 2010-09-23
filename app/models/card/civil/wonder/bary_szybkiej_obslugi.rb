class Card
  class Civil
    class Wonder
      class BarySzybkiejObslugi < Wonder
        def stages; [4,4,4,4]; end

        # Natychmiast otrzymujesz 1 [culture] za każdego robotnika będącego jednostką militarną lub w budynku publicznym; 2 [culture] za każdego robotnika na farmie lub w kopalni.
        def after_build(gc)
          super

          points = gc.player.player_cards(Card::Civil::Technology).sum do |m|
            case gc.card
            when Card::Civil::Technology::Unit then m.yellow_tokens * 1
            when Card::Civil::Technology::Urban then m.yellow_tokens * 1
            when Card::Civil::Technology::Farm then m.yellow_tokens * 2
            when Card::Civil::Technology::Mine then m.yellow_tokens * 2
            else 0
            end
          end

          gc.player.score_culture(points)
        end
      end
    end
  end
end