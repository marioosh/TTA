class Card
  class Civil
    class Technology
      class Government
        class Teokracja < Government
          def cost_science; 7; end
          def cost_revolution; 2; end
          def culture_scoring(gc); 1; end
          def happiness(gc); 2; end
          def urban_limit; 3; end
          def civil_actions; 4; end
          def military_actions; 3; end
        end
      end
    end
  end
end
