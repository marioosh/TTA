class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  
  has_many :game_cards, :dependent => :destroy, :order => 'game_cards.type', :include => :card
  has_many :player_actions, :dependent => :destroy

  # has_many :player_cards, :class_name => 'GameCard', :conditions => { :type => 'PlayerCard' }
  # has_many :player_hand,  :class_name => 'GameCard', :conditions => { :type => 'PlayerHand' }

  attr_accessor :password

  class Color
    NONE = 0
    RED =   1
    GREEN = 2
    BLUE =  3
    YELLOW = 4
  end

  def available_colors
    colors = [Color::RED, Color::GREEN, Color::BLUE, Color::YELLOW]
    self.game.players.each do |player|
      colors.each_index do |i|
        colors[i] = nil if colors[i] == player.color
      end unless player == self
    end

    return colors.compact
  end

  def color=(color)
    color = color.to_i
    raise Game::Error::InvalidStatus, "Gra się już rozpoczęła" unless self.game.status == Game::Status::WAITING_FOR_PLAYERS
    raise Game::Error::InvalidConfig, "Ten kolor jest już zajęty." unless color == Color::NONE || self.available_colors.index(color)
    write_attribute(:color, color)
  end
  
  def initial_setup
    # philosophy (x1), religion (x0), agriculture (x2), bronze (x2), warriors (x1)
    # worker pool: 1
    # blue bank: 18
    # yellow bank: 18+7 (25)

    Card.find(:all, :conditions => { :variant_id => 1, :min_players => self.position+1 }).each do |card|
      gc = self.game_cards.build(:card => card, :game => self.game)
      gc.type = 'PlayerCard'

      case card
      when Card::Civil::Technology::Mine
        # 2 workers for each farm and mine
        gc.yellow_tokens = 2
      when Card::Civil::Technology::Farm
        # 2 workers for each farm and mine
        gc.yellow_tokens = 2
      when Card::Civil::Technology::Unit::Infrantry
        # 1 worker as infrantry unit
        gc.yellow_tokens = 1
      when Card::Civil::Technology::Urban::Laboratory
        # 1 worker in basic laboratory building
        gc.yellow_tokens = 1
      end

      gc.save
    end

  end

  def next_round
    self.position >= self.game.current_player.position ? self.game.round : (self.game.round + 1)
  end

  def next_player
    self.game.players.find(:first, :conditions => [ 'position > ?', self.position ], :order => 'position ASC') || self.game.players.first
  end

  def prev_player
    self.game.players.find(:first, :conditions => [ 'position < ?', self.position ], :order => 'position DESC') || self.game.players.last
  end

  def tactics
    player_cards(Card::Military::Tactics).first
  end

  def tactics=(gc)
    raise Game::Error::ArgumentError, "Nieprawidłowa karta (wymagana karta Taktyki)." unless gc.card.is_a?(Card::Military::Tactics)

    # USUŃ Z GRY POPRZEDNIĄ TAKTYKĘ (JEŚLI TAKA BYŁA)
    tactics.discard! if tactics && tactics != gc

    # WYŁÓŻ KARTĘ TAKTYKI OBOK TWOJEJ PLANSZY CYWILIZACJI
    gc.type = GameCard::PlayerCard.to_s
    gc.player = self
    gc.save
  end

  def leader
    player_cards(Card::Civil::Leader).first
  end

  def leader=(gc)
    raise Game::Error::ArgumentError, "Nieprawidłowa karta (wymagana karta Lidera)." unless gc.card.is_a?(Card::Civil::Leader)
    
    # USUŃ Z GRY POPRZEDNIEGO LIDERA (JEŚLI TAKI BYŁ)
    leader.discard! if leader && leader != gc

    # WYŁÓŻ KARTĘ LIDERA OBOK TWOJEJ PLANSZY CYWILIZACJI
    gc.type = 'GameCard::PlayerCard'
    gc.player = self
    gc.save
  end

  def government
    player_cards(Card::Civil::Technology::Government).first
  end
  
  def government=(gc)
    raise Game::Error::ArgumentError, "Nieprawidłowa karta (wymagana karta Ustroju)." unless gc.card.is_a?(Card::Civil::Technology::Government)

    # USUŃ Z GRY POPRZEDNI USTRÓJ
    government.discard! if government && government != gc

    # WYŁÓŻ KARTĘ USTROJU OBOK TWOJEJ PLANSZY CYWILIZACJI
    gc.type = GameCard::PlayerCard.to_s
    gc.player = self
    gc.save
  end

  # TODO: calculate
  def happiness
    [8, self.player_cards.sum { |gc| gc.card.respond_to?(:happiness) ? gc.card.happiness(gc).to_i : 0 }].min
  end

  def blue_tokens_available
    # TODO: blue technology cards
    # TODO: events / aggressions
    # TODO: colonies
    return self.blue_tokens - self.game_cards.sum(:blue_tokens)
  end
  
  def yellow_tokens_available
    # TODO: blue technology cards
    # TODO: events / aggressions
    # TODO: colonies
    # TODO: -2 x game age (only for FULL GAME)
    return self.yellow_tokens - self.game_cards.sum(:yellow_tokens) - self.free_workers
  end

  def corruption
    return 6 if blue_tokens_available < 1
    return 4 if blue_tokens_available < 5
    return 2 if blue_tokens_available < 9
    return 0
  end

  def consumption
    return 6 if yellow_tokens_available < 1
    return 4 if yellow_tokens_available < 5
    return 3 if yellow_tokens_available < 9
    return 2 if yellow_tokens_available < 13
    return 1 if yellow_tokens_available < 17
    return 0
  end

  def minimum_happiness
    return 8 if yellow_tokens_available < 1
    return 7 if yellow_tokens_available < 3
    return 6 if yellow_tokens_available < 5
    return 5 if yellow_tokens_available < 7
    return 4 if yellow_tokens_available < 9
    return 3 if yellow_tokens_available < 11
    return 2 if yellow_tokens_available < 13
    return 1 if yellow_tokens_available < 17
    return 0
  end

  def population_cost
    return 7 if yellow_tokens_available <= 4
    return 5 if yellow_tokens_available <= 8
    return 4 if yellow_tokens_available <= 12
    return 3 if yellow_tokens_available <= 16
    return 2
  end

  def is_happy?
    return happiness + free_workers >= minimum_happiness
  end

  def happiness_workers
    [[minimum_happiness - happiness, 0].max, free_workers].min
  end
  
  def really_free_workers
    free_workers - happiness_workers
  end

  def player_wonder
    self.game_cards.each do |gc|
      return gc if gc.is_a?(GameCard::PlayerWonder)
    end

    return nil
  end

  def player_cards(type = nil)
    cards = []
    self.game_cards.each do |gc|
      cards << gc if gc.is_a?(GameCard::PlayerCard) && (type.nil? || gc.card.is_a?(type))
    end
    
    return cards
  end

  def player_hand(type = nil)
    cards = []
    self.game_cards.each do |gc|
      cards << gc if gc.is_a?(GameCard::PlayerHand) && (type.nil? || gc.card.is_a?(type))
    end

    return cards
  end

  def produce_food(options = {})
    amount = options.is_a?(Integer) ? options : options[:amount]

    if amount.nil?
      self.player_cards.each do |gc|
        gc.card.produce_food(gc) if gc.card.respond_to? :produce_food
      end

      # pay corruption only if all farms produce
      pay_consumption if options[:consumption].nil? || options[:consumption]
    elsif amount > 0
      farms = []
      self.player_cards.each do |gc|
        if gc.card.respond_to?(:produce_food) && gc.card.respond_to?(:food_value) && gc.card.food_value > 0
          farms << gc
        end
      end

      farms = farms.sort_by { |m| -m.card.food_value }
      farms.each do |m|
        if amount > 0
          tokens = amount / m.card.food_value
          amount = amount - tokens * m.card.food_value
          m.blue_tokens += tokens
          m.save
        end
      end
    end
  end

  def pay_consumption
    # TODO: co jezeli nie mozna wyzywic?!?
    pay_food(consumption)
  end

  def produce_resources(options = {})
    amount = options.is_a?(Integer) ? options : options[:amount]

    if amount.nil?
      self.player_cards.each do |gc|
        gc.card.produce_resources(gc) if gc.card.respond_to? :produce_resources
      end

      # pay corruption only if all mines produce
      pay_corruption if options[:corruption].nil? || options[:corruption]
    elsif amount > 0
      mines = []
      self.player_cards.each do |gc|
        if gc.card.respond_to?(:produce_resources) && gc.card.respond_to?(:resources_value) && gc.card.resources_value > 0
          mines << gc
        end
      end

      mines = mines.sort_by { |m| -m.card.resources_value }
      mines.each do |m|
        if amount > 0
          tokens = amount / m.card.resources_value
          amount = amount - tokens * m.card.resources_value
          m.blue_tokens += tokens
          m.save
        end
      end
    end
  end

  def pay_corruption
    pay_resources([corruption, available_resources].min)
  end

  def pay_resources(amount)
    raise Game::Error::InvalidAction, "Nie masz tyle surowcow!" if amount > available_resources

    mines = []
    self.player_cards.each do |gc|
      if gc.card.respond_to?(:produce_resources) && gc.card.respond_to?(:resources_value) && gc.card.resources_value > 0
        mines << gc
      end
    end

    mines.sort_by { |m| m.card.resources_value }
    mines.each do |m|
      if amount > 0
        to_pay = [m.card.available_resources(m), amount].min

        if to_pay > 0
          tokens = (to_pay.to_f / m.card.resources_value).ceil
          amount = amount - tokens * m.card.resources_value
          m.blue_tokens -= tokens
          m.save
        end
      end
    end

    self.produce_resources(:amount => -amount) if amount < 0
  end

  def pay_science(amount)
    raise Game::Error::InvalidAction, "Nie masz tyle nauki" if amount > points_science

    self.points_science -= amount
    self.save
  end
  
  def pay_food(amount)
    raise Game::Error::InvalidAction, "Nie masz tyle zywnosci!" if amount > available_food

    farms = []
    self.player_cards.each do |gc|
      if gc.card.respond_to?(:produce_food) && gc.card.respond_to?(:food_value) && gc.card.food_value > 0
        farms << gc
      end
    end

    farms.sort_by { |m| m.card.food_value }
    farms.each do |m|
      if amount > 0
        to_pay = [m.card.available_food(m), amount].min

        if to_pay > 0
          tokens = (to_pay.to_f / m.card.food_value).ceil
          amount = amount - tokens * m.card.food_value
          m.blue_tokens -= tokens
          m.save
        end
      end
    end

    self.produce_food(:amount => -amount) if amount < 0
  end

  def available_resources
    self.player_cards.sum { |gc| gc.card.respond_to?(:available_resources) ? gc.card.available_resources(gc) : 0 }
  end

  def available_food
    self.player_cards.sum { |gc| gc.card.respond_to?(:available_food) ? gc.card.available_food(gc) : 0 }
  end

  def score_science(points = nil)
    self.points_science += (points || science_scoring)
    self.save
  end

  def score_culture(points = nil)
    self.points_culture += (points || culture_scoring)
    self.save
  end

  def science_scoring
    self.player_cards.sum { |gc| gc.card.respond_to?(:science_scoring) ? gc.card.science_scoring(gc).to_i : 0 }
  end

  def culture_scoring
    self.player_cards.sum { |gc| gc.card.respond_to?(:culture_scoring) ? gc.card.culture_scoring(gc).to_i : 0 }
  end

  def strength
    self.player_cards.sum { |gc| gc.card.respond_to?(:strength) ? gc.card.strength(gc).to_i : 0 }
  end

  def draw_military_card
    card = self.game.military_deck.shift
    card.action!(:take, self).process!
  end

  def urban_limit
    self.government.card.urban_limit
  end

  def increase_population
    raise Game::Error::InvalidAction, "Nie masz już żadnych robotników w banku." if yellow_tokens_available < 1

    self.free_workers += 1
    self.save
  end

  # NIE MOŻESZ DOBRAĆ KARTY CYWILNEJ JEŚLI PO JEJ DOBRANIU LICZBA KART NA
  # RĘKU PRZEKROCZYŁABY LICZBĘ TWOICH BIAŁYCH ZNACZNIKÓW.
  def max_civil_cards
    # TODO: check for cards callback (Biblioteka Aleksandryjska)
    return max_civil_actions
  end

  def max_military_cards
    # TODO: check for cards callback (Biblioteka Aleksandryjska)
    return max_military_actions
  end

  # TODO: calculate
  def max_civil_actions
    # W TRAKCIE PIERWSZEJ RUNDY GRACZ ROZPOCZYNAJĄCY MOŻE ZUŻYĆ TYLKO 1 AKCJĘ
    # CYWILNĄ. DRUGI GRACZ MOŻE UŻYĆ TYLKO 2, TRZECI 3, GRACZ CZWARTY MOŻE
    # ZUŻYĆ WSZYSTKIE 4.
    return self.position+1 if self.game.round == 0
    self.player_cards.sum { |gc| gc.card.respond_to?(:civil_actions) ? gc.card.civil_actions : 0 }
  end

  def max_military_actions
    # first round - no military actions
    return 0 if self.game.round == 0
    self.player_cards.sum { |gc| gc.card.respond_to?(:military_actions) ? gc.card.military_actions : 0 }
  end
  
  def used_civil_actions
    return self.player_actions.sum(:actions, :conditions => [ "round = ? AND type LIKE 'PlayerAction::Civil::%'", self.game.round ])
  end
  
  def used_military_actions
    return self.player_actions.sum(:actions, :conditions => [ "round = ? AND type LIKE 'PlayerAction::Military::%'", self.game.round ])
  end
  
  def used_political_action?
    return self.player_actions.sum(:actions, :conditions => [ "round = ? AND type LIKE 'PlayerAction::Political::%'", self.game.round ]) > 0
  end
  
  def civil_actions_left
    max_civil_actions - used_civil_actions
  end

  def military_actions_left
    max_military_actions - used_military_actions
  end

  # small negative value for tie breaking
  # (-0.0 for current player, -0.1 for next player, ...)
  def relative_offset
    active_position = self.game.player.position
    if self.position >= active_position
      return (active_position - self.position) / 10
    else
      return (active_position - self.position - self.game.number_of_players) / 10
    end
  end

  def relative_strength
    strength + relative_offset
  end

  def relative_science_rating
    science_scoring + relative_offset
  end

  def relative_culture_rating
    culture_scoring + relative_offset
  end
end