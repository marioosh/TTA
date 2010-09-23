class Game
  class Civilization
    class Advanced < Civilization
      def max_age; return 2; end

      # TODO: create 4 cards deck of Age III Military cards
      # TODO: remove all Civil::Military::War
      def start_game(user = nil)
        super
        # ...
      end

      def end_game
        # TODO: score events on Age III Military cards
      end
    end
  end
end
