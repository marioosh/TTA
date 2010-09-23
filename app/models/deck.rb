class Deck < ActiveRecord::Base
  belongs_to :game
  has_and_belongs_to_many :cards, :order => 'RAND()'

  class CivilDeck < Deck
    def type_of_cards; return 'Card::Civil'; end
  end

  class MilitaryDeck < Deck
    def type_of_cards; return 'Card::Military'; end
  end

  class CurrentEvents < Deck
    def type_of_cards; return 'Card::Military'; end
    def refill
      case self.game.level
        when Game::Level::BASIC
          # TODO: remove Development of Politics
          super
        else
          super(self.game.number_of_players + 2)
      end
    end
  end

  class PastEvents < Deck
  end

  class FutureEvents < Deck
  end

  class AdvancedGame < Deck
    def type_of_cards; return 'Card::Military'; end
    def refill
      super(4, 3) if self.game.level == Game::Level::ADVANCED
    end
  end

  def refill(limit = nil, age = nil)
    if self.respond_to? :type_of_cards
      age ||= self.game.age
      tmp = Card.find(:all, :conditions => [ 'age = ? AND type = ? AND (min_players IS NULL OR min_players <= ?)', age, type_of_cards, self.game.number_of_players ], :order => 'RAND()', :limit => limit)
      tmp.each do |card|
        self.cards << card
      end
    end
  end

  def empty?
    cards.length == 0
  end

  def draw_card

  end

  def put_card

  end
end