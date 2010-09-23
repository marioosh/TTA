class Card
  class Civil
    class Technology
      class Urban < Technology

        def available_actions(type, phase, gc = nil)
          options = super
          if type == GameCard::PlayerCard && phase == Game::Civilization::Phase::ACTIONS
            options[:build] = PlayerAction::Civil::Build::Building
            options[:upgrade] = PlayerAction::Civil::Upgrade::Building
            options[:destroy] = PlayerAction::Civil::Destroy::Building
          end
          return options
        end

        def culture_scoring(gc)
          raise ArgumentError, "gc has to be a GameCard" unless gc.is_a?(GameCard)
          gc.yellow_tokens * culture_value if self.respond_to?(:culture_value)
        end

        def science_scoring(gc)
          raise ArgumentError, "gc has to be a GameCard" unless gc.is_a?(GameCard)
          gc.yellow_tokens * science_value if self.respond_to?(:science_value)
        end

        def happiness(gc)
          raise ArgumentError, "gc has to be a GameCard" unless gc.is_a?(GameCard)
          gc.yellow_tokens * happy_faces if self.respond_to?(:happy_faces)
        end

        def strength(gc)
          raise ArgumentError, "gc has to be a GameCard" unless gc.is_a?(GameCard)
          gc.yellow_tokens * strength_value if self.respond_to?(:strength_value)
        end

        class Temple < Urban
          def culture_value; return 1; end
          def happy_faces
            case self.age
            when 0 then 1
            when 1 then 2
            when 2 then 3
            end
          end

          def cost_resources
            case self.age
            when 0 then 3
            when 1 then 5
            when 2 then 7
            end
          end

          def cost_science
            case self.age
            when 1 then 2
            when 2 then 4
            end
          end
        end

        class Laboratory < Urban
          def science_value
            case self.age
            when 0 then 1
            when 1 then 2
            when 2 then 3
            when 3 then 5
            end
          end

          def cost_resources
            case self.age
            when 0 then 3
            when 1 then 6
            when 2 then 8
            when 3 then 10
            end
          end

          def cost_science
            case self.age
            when 1 then 4
            when 2 then 6
            when 3 then 8
            end
          end
        end

        class Library < Urban
          def science_value
            case self.age
            when 1 then 1
            when 2 then 2
            when 3 then 3
            end
          end

          def culture_value
            case self.age
            when 1 then 1
            when 2 then 2
            when 3 then 3
            end
          end

          def cost_resources
            case self.age
            when 1 then 4
            when 2 then 8
            when 3 then 11
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

        class Arena < Urban
          def happy_faces
            case self.age
            when 1 then 2
            when 2 then 3
            when 3 then 4
            end
          end

          def strength_value
            case self.age
            when 1 then 1
            when 2 then 2
            when 3 then 3
            end
          end

          def cost_resources
            case self.age
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

        class Theatre < Urban
          def culture_value
            case self.age
            when 1 then 2
            when 2 then 3
            when 3 then 4
            end
          end

          def happy_faces; return 1; end

          def cost_resources
            case self.age
            when 1 then 5
            when 2 then 9
            when 3 then 12
            end
          end

          def cost_science
            case self.age
            when 1 then 4
            when 2 then 7
            when 3 then 10
            end
          end
        end
      end
    end
  end
end
