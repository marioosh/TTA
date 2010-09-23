class Game < ActiveRecord::Base
  has_many :players, :dependent => :destroy, :order => :position
  has_many :game_cards, :dependent => :destroy, :order => 'position, RAND()', :include => :card
  has_many :game_events, :dependent => :destroy, :order => 'created_at DESC'
  has_many :player_actions, :through => :players
  
  belongs_to :user
  belongs_to :current_action, :class_name => "PlayerAction"

  has_and_belongs_to_many :variants

  CARD_ROW_LENGTH = 13

  class Error < StandardError
    class TooManyPlayers < Error; end
    class NotEnoughPlayers < Error; end
    class InvalidStatus < Error; end
    class NotPermitted < Error; end
    class InvalidAction < Error; end
    class ArgumentError < Error; end
    class InvalidConfig < Error; end
  end

  class Status
    ABORTED = 0
    WAITING_FOR_PLAYERS = 1
    IN_PROGRESS = 2
    FINISHED = 3
  end

  def abort!
    self.game_events.create(:description => "Gra została zakończona.")
    self.status = Game::Status::ABORTED
    self.save!
  end

  def main_loop(params = nil)
    return true
  end

  def player
    self.active_player || self.current_player
  end

  def current_player
    return self.players.find_by_position(self.current_player_position) if self.current_player_position
  end

  def current_player=(player)
    self.current_player_position = player.nil? ? nil : player.position
  end

  def active_player
    return self.players.find_by_position(self.active_player_position) if self.active_player_position
  end

  def active_player=(player)
    self.active_player_position = player.nil? ? nil : player.position
  end

  def is_player?(user)
    user = User.find(user) if user.is_a? Integer
    return self.players.find_by_user_id(user.id) if user.is_a? User
  end

  def is_full?
    return number_of_players == self.max_players
  end

  def join_player(user, password = nil)
    unless player = self.is_player?(user)
      raise Error::InvalidStatus, 'Gra już się rozpoczęła, nie możesz dołączyć!' unless self.status == Game::Status::WAITING_FOR_PLAYERS
      raise Error::TooManyPlayers, 'Gra jest już pełna!' if self.is_full?
      raise Error::NotPermitted, 'Aby dołączyć do tej gry, musisz podać hasło.' if user != self.user && password != self.password && !self.password.blank?

      user = User.find(user) if user.is_a? Integer
      player = self.players.create(:user => user)
      self.game_events.create(:description => "Użytkownik #{user.profile.name} dołączył do gry.")
      return player
    end
  end

  def number_of_players
    self.players.length
  end

  def reset_game
    # reset player order
    Player.update_all( "position = NULL", "game_id = #{self.id}" )

    # remove actions
    self.players.each do |player|
      PlayerAction.delete_all("player_id = #{player.id}")
    end

    # remove cards
    self.game_cards.each { |gc| gc.destroy }
    self.status = Status::WAITING_FOR_PLAYERS
    self.phase = nil
    self.current_player = nil
    self.active_player = nil
    self.round = 0
    self.age = 0

    self.save
  end
  
  def start_game(user = nil)
    raise Error::InvalidStatus, 'Gra została zakończona.' if self.status == Game::Status::ABORTED || self.status == Game::Status::FINISHED
    raise Error::InvalidStatus, 'Gra została już rozpoczęta.' if self.status == Game::Status::IN_PROGRESS
    raise Error::NotPermitted, 'Tylko założyciel gry może ją rozpocząć.' if user && self.user && self.user != user
    raise Error::NotEnoughPlayers, 'Do rozpoczęcia gry wymagane są co najmniej 2 osoby.' if number_of_players < 2

    self.players.each do |player|
      raise Error, "Gracz #{player.user.profile.name} nie ma określonego koloru." if player.color.nil? || player.color.zero?
    end

    # random player order and initial setup
    position = 0
    self.players.sort! { |a,b| rand }
    self.players.each do |player|
      player.position = position
      player.save

      player.initial_setup

      self.current_player = player if position == 0
      position += 1
    end

    # change status
    self.status = Status::IN_PROGRESS
    self.save

    self.game_events.create(:user => user, :description => 'Gra została rozpoczęta.')
    return self
  end

end