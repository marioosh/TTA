class Card
  class Civil
    class Wonder
      class PalacKulturyINauki < Wonder
        def stages; [5,3,3,5]; end

        # Natychmiast otrzymujesz tyle [culture] ile wynosi Twój przyrost kultury i 1/4/9/16 [culture] za wystawione 1/2/3/4 różne karty specjalnych (niebieskich) technologii.
        def after_build(gc)
          super

          points = gc.player.culture_scoring
          points += [1,4,9,16].at(gc.player.player_cards(Card::Civil::Technology::Special).length-1)
          gc.player.score_culture(points)
        end
      end
    end
  end
end