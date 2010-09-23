class Card
  class Civil
    class Wonder
      class KolosRodyjski < Wonder
        # TODO: W czasie kolonizacji nowego terytorium masz bonus +1.
        def stages; [3,3]; end
        def culture_scoring(gc); 1; end
        def strength(gc); 1; end
        def colonization_bonus(gc); 1; end
      end
    end
  end
end
