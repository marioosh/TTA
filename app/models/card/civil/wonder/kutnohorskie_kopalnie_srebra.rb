class Card
  class Civil
    class Wonder
      class KutnohorskieKopalnieSrebra < Wonder
        # TODO: Przy zagrywaniu żółtych kart masz +1 do ich efektu (więcej surowców, żywności, punktów nauki, kultury, większe zniżki, ale nie więcej akcji militarnych).
        def stages; [2,3,4]; end
        def strength(gc); 2; end
        def science_scoring(gc); 1; end
      end
    end
  end
end