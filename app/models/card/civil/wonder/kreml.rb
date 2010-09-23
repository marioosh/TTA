class Card
  class Civil
    class Wonder
      class Kreml < Wonder
        # Zyskujesz 1 akcję cywilną i 1 akcję militarną.
        def stages; [4,4,4]; end
        def culture_scoring(gc); 3; end
        def happiness(gc); -2; end
        def civil_actions; 1; end
        def military_actions; 1; end
      end
    end
  end
end