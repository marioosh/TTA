class Card
  class Civil
    class Technology
      class Special
        class Murarstwo < Special
          def cost_science
            case self.age
            when 1 then 3
            when 2 then 6
            when 3 then 9
            end
          end

          # TODO: dzialanie architektury
        end
      end
    end
  end
end