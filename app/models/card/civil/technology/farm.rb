class Card
  class Civil
    class Technology
      class Farm < Technology
        def available_actions(type, phase, gc = nil)
          options = super
          if type == GameCard::PlayerCard && phase == Game::Civilization::Phase::ACTIONS
            options[:build] = PlayerAction::Civil::Build::Farm
            options[:upgrade] = PlayerAction::Civil::Upgrade::Farm
            options[:destroy] = PlayerAction::Civil::Destroy::Farm
          end

          # player-specific restrains
          unless gc.nil?
            options.delete(:destroy) if gc.yellow_tokens == 0

            upgrade = false
            gc.player.player_cards(Card::Civil::Technology::Farm).each do |pc|
              upgrade = true if pc.card.age > self.age
            end

            options.delete(:upgrade) unless upgrade
          end

          return options
        end

        def produce_food(gc, amount = nil)
          raise ArgumentError, "gc has to be a GameCard" unless gc.is_a?(GameCard)
          gc.blue_tokens += [amount || gc.yellow_tokens, gc.player.blue_tokens_available].min
          gc.save
        end

        def available_food(gc)
          self.food_value * gc.blue_tokens
        end
        
        def food_value
          case self.age
          when 0 then 1
          when 1 then 2
          when 2 then 3
          when 3 then 5
          end
        end

        def cost_resources
          case self.age
          when 0 then 2
          when 1 then 4
          when 2 then 6
          when 3 then 8
          end
        end

        def cost_science
          case self.age
          when 1 then 3
          when 2 then 5
          when 3 then 7
          end
        end
      end
    end
  end
end