class Card
  class Civil
    class Wonder
      class KopalniaSoliWWieliczce < Wonder
        def stages; [4,1,4]; end
        def blue_tokens; 2; end

        # Jedna z Twoich kopalń poziomu A lub I produkuje dwa razy tyle [resource].
        def produce_resources(gc)
          mines = gc.player.player_cards(Card::Civil::Technology::Mine)
          best = nil
          
          mines.each do |mine|
            best = mine if mine.card.age <= 1 && mine.yellow_tokens > 0 && (best.nil? || best.card.age < mine.card.age)
          end

          unless best.nil?
            best.blue_tokens +=1
            best.save
          end
        end

        # Jedna z Twoich farm poziomu A lub I produkuje dwa razy tyle [food].
        def produce_food(gc)
          farms = gc.player.player_cards(Card::Civil::Technology::Farm)
          best = nil

          farms.each do |farm|
            best = farm if farm.card.age <= 1 && farm.yellow_tokens > 0 && (best.nil? || best.card.age < farm.card.age)
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