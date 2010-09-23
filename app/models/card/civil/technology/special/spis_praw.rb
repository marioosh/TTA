class Card
  class Civil
    class Technology
      class Special
        class SpisPraw < Special
          def cost_science
            case self.age
            when 1 then 6
            when 2 then 7
            when 3 then 10
            end
          end

          def civil_actions
            case self.age
            when 1 then 1
            when 2 then 1
            when 3 then 2
            end
          end

          def blue_tokens
            case self.age
            when 1 then 0
            when 2 then 3
            when 3 then 3
            end
          end
        end
      end
    end
  end
end