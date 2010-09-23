class Game
  class Civilization < Game

    AVAILABLE_TYPES = [Game::Civilization::Basic, Game::Civilization::Advanced, Game::Civilization::Full]

    class Phase
      CARD_ROW = 1
      WAR_OUTCOME = 2
      POLITICAL_ACTION = 3
      DISCARD_EXCESS_MILITARY_CARDS = 4
      ACTIONS = 5
      MAINTENANCE = 6
      END_TURN = 7

      # resolve aggression
      AGGRESSION_ATTACK = 15
      AGGRESSION_DEFEND = 16

      # resolve war
      WAR_ATTACK = 25
      WAR_DEFEND = 26

      # resolve colonization
      COLONIZATION_PAY = 35
    end

    # main_loop(params) returns a result String
    # with a template name to render, for example:
    # return 'political'  -> render :action => "game/phases/political"
    # or FALSE if there should be redirect:
    # return false        -> redirect_to game_url(:id => @game)
    def main_loop(params, user)
      result = nil

      while result.nil? && user && user == self.player.user do
        self.transaction do
          if self.current_action
            self.current_action.process!
            self.current_action = nil
            self.save

            # redirect after action is processed
            return false
          else
            result = case self.phase
                     when Phase::CARD_ROW then phase_card_row(params)
                     when Phase::WAR_OUTCOME then phase_war_outcome(params)
                     when Phase::POLITICAL_ACTION then phase_political_action(params)
                     when Phase::DISCARD_EXCESS_MILITARY_CARDS then phase_discard_excess_military_cards(params)
                     when Phase::ACTIONS then phase_actions(params)
                     when Phase::MAINTENANCE then phase_maintenance(params)
                     when Phase::END_TURN then phase_end_turn(params)
                     else self.phase += 1; nil
                     end

          end
        end

        # self.reload
        params[:phase] = nil
      end

      return result
    end

    def phase_card_row(params)
      if params[:phase] == 'finish' || self.round == 0
        if self.round > 0
          remove_card_row_cards
          slide_card_row_cards
          fill_card_row
          end_of_age if self.round == 1 && self.age == 0
        end

        self.phase += 1
        self.save
        return false
      end

      # start turn
      return 'card_row'
    end

    def phase_war_outcome(params)
      self.phase += 1
      self.save
      return false
    end

    def phase_political_action(params)
      if params[:phase] == 'finish' || self.current_player.used_political_action? || self.round < 2
        self.phase += 1
        self.save
        return false
      end

      # choose your action
      return 'political_action'
    end

    def phase_discard_excess_military_cards(params)
      return 'discard_excess_military_cards' if self.player.player_hand(Card::Military).length > self.player.max_military_cards
      
      self.phase += 1
      self.save
      return false
    end

    def phase_actions(params)
#      gc = GameCard.find(params[:gc]) if params[:gc]
#      return gc.process!(params[:phase]) if gc && params[:phase]

      if params[:phase] == 'finish'
        self.phase += 1
        self.save
        return false
      end

      # choose your action
      return 'actions'
    end

    def phase_maintenance(params)
      if self.player.is_happy?
        phase_maintenance_add_points
        phase_maintenance_draw_cards
        phase_maintenance_produce_food
        phase_maintenance_produce_resources
      end

      self.phase += 1
      self.save
      return nil
    end

    def phase_maintenance_add_points
      self.player.score_science
      self.player.score_culture
    end

    def phase_maintenance_draw_cards
      max = [3, self.player.military_actions_left].min
      max.times { self.player.draw_military_card }
    end

    def phase_maintenance_produce_food
      self.player.produce_food(:amount => nil, :consumption => true)
    end

    def phase_maintenance_produce_resources
      self.player.produce_resources(:amount => nil, :corruption => true)
    end

    def phase_end_turn(params)
      self.phase = Phase::CARD_ROW
      self.current_player = self.current_player.next_player
      self.round += 1 if self.current_player.position.zero?
      self.save
      
      return false
    end

    def start_game(user = nil)
      # standard game start
      super

      # get cards into the game
      create_civil_military_deck
      create_current_events_deck

      # create card row
      fill_card_row

      # initial phase
      self.phase = Phase::ACTIONS
      self.save

      return self
    end

    def create_civil_military_deck
      # default setup: variant_id = 1
      # base deck: variant_id = 2
      ids = [2] + self.variant_ids
      cards = Card.find(:all, :conditions => [ "min_players <= ? AND variant_id IN (?) AND age = ?", self.number_of_players, ids, self.age ], :order => 'RAND()')
      cards.each do |card|
        unless card.age == 0 && card.is_a?(Card::Military)
          gc = self.game_cards.build(:card => card)
          gc.type = card.is_a?(Card::Civil) ? 'GameCard::CivilDeck' : 'GameCard::MilitaryDeck'
          gc.save
        end
      end
    end

    def create_current_events_deck
      ids = [2] + self.variant_ids

      limit = self.number_of_players + 2
      cards = Card.find(:all, :conditions => [ "variant_id IN (?) AND age = ? AND type = ?", ids, 0, 'Military::Event' ], :limit => limit, :order => 'RAND()')
      cards.each do |card|
        gc = self.game_cards.build(:card => card)
        gc.type = 'GameCard::CurrentEvent'
        gc.save
      end
    end

    def card_row
      row = []
      cards = self.game_cards.where( :type => 'GameCard::CardRow' )

      cards.each do |card|
        row[card.position] = card
      end

      return row
    end

    # dodaje nowe karty na koniec toru kart
    # tor musi byc juz uporzadkowany (karty dosuniete do lewej: slide_card_row_cards)
    def fill_card_row
      missing = CARD_ROW_LENGTH - card_row.length
      missing.times do
        add_card_row_card
      end
    end

    # dodaje nową kartę ze stosu kart cywilnych na zadana pozycje na torze kart
    def add_card_row_card(position = nil)
      if card = civil_deck.shift
        position ||= card_row.length
        card.type = 'GameCard::CardRow'
        card.position = position
        card.save
      end

      end_of_age if civil_deck.empty?
    end

    def card_row_discard_size
      5 - self.number_of_players
    end

    # odrzuca pierwsze karty (w zaleznosci od liczby graczy)
    def remove_card_row_cards
      card_row.each do |gc|
        gc.discard! if gc && gc.position < self.card_row_discard_size
      end
    end

    # przesuwa karty do lewej
    def slide_card_row_cards
      i = 0
      card_row.each do |card|
        if card
          card.position = i
          card.save
          i += 1
        end
      end
    end

    def civil_deck
      self.game_cards.find(:all, :conditions => { :type => 'GameCard::CivilDeck' })
    end

    def military_deck
      self.game_cards.find(:all, :conditions => { :type => 'GameCard::MilitaryDeck' })

      # TODO: if military deck is empty - compose new deck of cards from DiscardPile
    end

    def current_events
      self.game_cards.find(:all, :conditions => { :type => 'GameCard::CurrentEvent' })
    end

    def past_events
      self.game_cards.find(:all, :conditions => { :type => 'GameCard::PastEvent' })
    end

    def future_events
      self.game_cards.find(:all, :conditions => { :type => 'GameCard::FutureEvent' })
    end

    # sprawdza czy gra powinna sie juz skonczyc
    # TODO: gra nie powinna konczyc sie natychmiast !!
    def game_end?
      end_game if self.age >= max_age
    end

    # koniec epoki
    def end_of_age
      # TODO: discard leaders, wonders, cards from hand, pacts
      self.age += 1
      self.save

      # discard civil and military decks
      civil_deck.each { |gc| gc.discard! }
      military_deck.each { |gc| gc.discard! }

      # create new decks
      create_civil_military_deck

      game_end?
    end

    def strongest(number = 1)
      array = self.players.sort { |a,b| a.relative_strength <=> b.relative_strength }
      return array[-number, number]
    end

    def two_strongest
      return strongest if number_of_players == 2
      return strongest(2)
    end

    def weakest(number = 1)
      array = self.players.sort { |a,b| a.relative_strength <=> b.relative_strength }
      return array[0, number]
    end

    def two_weakest
      return weakest if number_of_players == 2
      return weakest(2)
    end
  end
end
