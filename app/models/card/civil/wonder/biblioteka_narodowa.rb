class Card
  class Civil
    class Wonder
      class BibliotekaNarodowa < Wonder
        def stages; [0,0,10,6]; end
        # TODO: Na początku epoki IV, jeżeli cud nie jest jeszcze zbudowany, odrzuć go.

        # Natychmiast otrzymujesz 5 [culture] za każdą niewykorzystaną jeszcze akcję cywilną.
        def after_build(gc)
          super

          points = gc.player.civil_actions_left * 5
          gc.player.score_culture(points)
        end
      end
    end
  end
end