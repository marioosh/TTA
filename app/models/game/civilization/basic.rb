class Game
  class Civilization
    class Basic < Civilization
      def max_age; return 1; end

      def start_game(user = nil)
        super
        # ...
      end

      def create_current_events_deck
        ids = [2] + self.variant_ids

        # remove Development of politics (card_id = 266)
        cards = Card.find(:all, :conditions => [ "variant_id IN (?) AND age = ? AND type = ? AND id != ?", ids, 0, 'Military::Event', 266 ], :order => 'RAND()')
        cards.each do |card|
          gc = self.game_cards.build(:card => card)
          gc.type = 'CurrentEvent'
          gc.save
        end
      end

      def end_game
        # TODO: 2 culture for each level I technology
        #       2 culture for each point of strength
        #       2 culture for each happy face (max 16)
        #       1 culture for every science+
        #       1 culture for every food and resource production
      end
    end
  end
end
