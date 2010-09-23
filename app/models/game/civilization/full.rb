class Game
  class Civilization
    class Full < Civilization
      def max_age; return 3; end
      def end_game
        # TODO: score events on FutureEvents
      end

      # NA KONIEC EPOKI I, II I III, KAŻDA CYWILIZACJA MUSI ODRZUCIĆ
      # 2 ŻÓŁTE ZNACZNIKI Z ŻÓŁTEGO BANKU.
      def end_of_age
        super
        self.players.each do |player|
          player.yellow_tokens -= 2
          player.save
        end if self.age > 1
      end
    end
  end
end