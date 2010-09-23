class Card
  class Civil
    class Technology
      class Special
        class Kartografia < Special
          def cost_science
            case self.age
            when 1 then 4
            when 2 then 6
            when 3 then 8
            end
          end

          def strength(gc)
            case self.age
            when 1 then 1
            when 2 then 2
            when 3 then 3
            end
          end

          def colonization_bonus(gc)
            case self.age
            when 1 then 2
            when 2 then 3
            when 3 then 4
            end
          end
        end
      end
    end
  end
end