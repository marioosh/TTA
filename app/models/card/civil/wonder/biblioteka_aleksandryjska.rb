class Card
  class Civil
    class Wonder
      class BibliotekaAleksandryjska < Wonder
        # TODO: Możesz mieć 1 dodatkową kartę cywilną i 1 dodatkową kartę militarną w ręku.
        def stages; [1,2,2,1]; end
        def culture_scoring(gc); 1; end
        def science_scoring(gc); 1; end
      end
    end
  end
end
