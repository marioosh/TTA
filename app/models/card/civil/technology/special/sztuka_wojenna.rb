class Card
  class Civil
    class Technology
      class Special
        class SztukaWojenna < Special
          def cost_science
            case self.age
            when 1 then 4
            when 2 then 8
            when 3 then 12
            end
          end

          def strength(gc)
            case self.age
            when 1 then 1
            when 2 then 3
            when 3 then 5
            end
          end

          def military_actions
            case self.age
            when 1 then 1
            when 2 then 2
            when 3 then 3
            end
          end
        end
      end
    end
  end
end