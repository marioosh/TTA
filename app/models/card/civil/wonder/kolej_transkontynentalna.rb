class Card
  class Civil
    class Wonder
      class KolejTranskontynentalna < Wonder
        def stages; [3,4,5]; end
        def strength(gc); 5; end

        # Jedna z Twoich najlepszych kopalni [mine] produkuje dwa razy tyle [resource] (jeden z robotników na niej produkuje dwa niebieskie znaczniki zamiast 1).
        # TODO: combine with Wieliczka (!)
        def produce_resources(gc)
          mines = gc.player.player_cards(Card::Civil::Technology::Mine)
          best = nil

          mines.each do |mine|
            best = mine if mine.yellow_tokens > 0 && (best.nil? || best.card.age < mine.card.age)
          end

          unless best.nil?
            best.blue_tokens +=1
            best.save
          end
        end
      end
    end
  end
end