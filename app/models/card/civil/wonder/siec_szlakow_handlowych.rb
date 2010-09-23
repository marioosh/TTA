class Card
  class Civil
    class Wonder
      class SiecSzlakowHandlowych < Wonder
        # W epoce I produkuje 1 surowiec. W epoce II produkuje 1 nauki. W epoce III i IV produkuje 1 kultury.
        def stages; [3,1,2]; end
        def culture_scoring(gc); 1 if gc.game.age > 2; end
        def science_scoring(gc); 1 if gc.game.age == 2; end
        def blue_tokens(gc); 1; end
        def yellow_tokens(gc); 1; end

        def produce_resources(gc)
          gc.player.produce_resources(1) if gc.game.age < 2
        end
      end
    end
  end
end