class Card
  class Civil
    class Technology
      class Mine < Technology
        def available_actions(type, phase, gc = nil)
          options = super
          if type == GameCard::PlayerCard && phase == Game::Civilization::Phase::ACTIONS
            options[:build] = PlayerAction::Civil::Build::Mine
            options[:upgrade] = PlayerAction::Civil::Upgrade::Mine
            options[:destroy] = PlayerAction::Civil::Destroy::Mine
          end
          return options
        end

        def produce_resources(gc, amount = nil)
          raise ArgumentError, "gc has to be a GameCard" unless gc.is_a?(GameCard)
          gc.blue_tokens += [amount || gc.yellow_tokens, gc.player.blue_tokens_available].min
          gc.save
        end

        def available_resources(gc)
          self.resources_value * gc.blue_tokens
        end
        
        def resources_value
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
          when 1 then 5
          when 2 then 8
          when 3 then 11
          end
        end

        def cost_science
          case self.age
          when 1 then 5
          when 2 then 7
          when 3 then 9
          end
        end
      end
    end
  end
end