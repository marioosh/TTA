class Card
  class Civil
    class Technology
      class Unit < Technology
        def available_actions(type, phase, gc = nil)
          options = super
          if type == GameCard::PlayerCard && phase == Game::Civilization::Phase::ACTIONS
            options[:build] = PlayerAction::Military::BuildUnit
            options[:upgrade] = PlayerAction::Military::UpgradeUnit
            options[:destroy] = PlayerAction::Military::DestroyUnit
          end

          if type == GameCard::PlayerCard && [Game::Civilization::Phase::AGGRESSION_ATTACK, Game::Civilization::Phase::AGGRESSION_DEFEND, Game::Civilization::Phase::WAR_ATTACK, Game::Civilization::Phase::WAR_DEFEND, Game::Civilization::Phase::COLONIZATION_PAY].index(phase)
            options[:sacrifice] = PlayerAction::Special::SacrificeUnit
          end
          return options
        end

        def is_antiquated?(age)
          return true if age > self.age + 1
        end

        def strength(gc)
          raise ArgumentError, "gc has to be a GameCard" unless gc.is_a?(GameCard)
          gc.yellow_tokens * strength_value if self.respond_to? :strength_value
        end
        
        class Infrantry < Unit
          def strength_value
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
            when 1 then 3
            when 2 then 5
            when 3 then 7
            end
          end

          def cost_science
            case self.age
            when 1 then 3
            when 2 then 5
            when 3 then 8
            end
          end
        end

        class Artillery < Unit
          def strength_value
            case self.age
            when 2 then 3
            when 3 then 5
            end
          end

          def cost_resources
            case self.age
            when 2 then 5
            when 3 then 7
            end
          end

          def cost_science
            case self.age
            when 2 then 7
            when 3 then 10
            end
          end
        end

        class Cavalry < Unit
          def strength_value
            case self.age
            when 1 then 2
            when 2 then 3
            when 3 then 5
            end
          end

          def cost_resources
            case self.age
            when 1 then 3
            when 2 then 5
            when 3 then 7
            end
          end

          def cost_science
            case self.age
            when 1 then 4
            when 2 then 6
            when 3 then 9
            end
          end
        end
        
        class AirForce < Unit
          def strength_value
            # TODO: JEDNOSTKA LOTNICTWA MOŻE BYĆ CZĘŚCIĄ KAŻDEJ ARMII.
            #       DUBLUJE ONA WARTOŚĆ UŻYTEJ KARTY TAKTYKI DLA TEJ ARMII.
            case self.age
            when 3 then 5
            end
          end

          def cost_resources
            case self.age
            when 3 then 7
            end
          end

          def cost_science
            case self.age
            when 3 then 11
            end
          end
        end
      end

    end
  end
end
