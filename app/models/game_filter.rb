class GameFilter
  attr_accessor :no_password, :waiting, :ranking, :exclude_user

  def initialize(attributes = nil)
    if attributes.is_a? Hash
      self.no_password = attributes[:no_password] == '1'
      self.waiting = attributes[:waiting].nil? ? true : (attributes[:waiting] == '1')
      self.ranking = attributes[:ranking] == '1'
      self.exclude_user = attributes[:exclude_user]
    end
  end

  def games
    @games = Game.order('updated_at DESC').where('status != ? AND status != ?', Game::Status::ABORTED, Game::Status::FINISHED)

    # pokazuj tylko bez hasła
    @games = @games.where(:password => '') if self.no_password

    # pokazuj tylko rankingowe
    @games = @games.where(:ranking => true) if self.ranking

    # pokazuj tylko oczekujace, z wolnymi miejscami
    if self.waiting
      @games = @games.where(:status => Game::Status::WAITING_FOR_PLAYERS)
      @games.delete_if do |game|
        game.max_players <= game.number_of_players
      end
    end

    # bez konkretnego uzytkownika
    @games.delete_if do |game|
      game.is_player?(self.exclude_user)
    end if self.exclude_user

    return @games
  end
end