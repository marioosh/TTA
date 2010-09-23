module Site::GamesHelper
  def add_game_breadcrumb(game)
    add_breadcrumb game_title(game)
  end

  def game_type(value)
    value = value.class.to_s if value.is_a?(Game)
    value = value.to_s if value.is_a?(Class)
    
    t("game.type.#{value.downcase.gsub('game::', '').gsub('::', '.')}")
  end

  def game_status(value)
    return t("game.status.#{value}") unless value.is_a?(Game)

    status = t("game.status.#{value.status}")
    if value.status == Game::Status::IN_PROGRESS
       status << " (#{value.player.user.profile.name})"
    end

    return status
  end

  def game_speed(value)
    value = value.max_time if value.is_a?(Game)
    t("game.speed.#{value}")
  end

  def game_title(game)
    description = "Rozgrywka \##{game.id}"
    description += " (#{h(game.description)})" unless game.description.nil? || game.description.empty?
    description += " - PRZERWANA" if game.status == Game::Status::ABORTED
    description += " - ZAKOŃCZONA" if game.status == Game::Status::FINISHED
    return description
  end

  def game_age(game)
    return 'A' if game.age == 0
    return 'I' if game.age == 1
    return 'II' if game.age == 2
    return 'III' if game.age == 3
    return 'IV' if game.age == 4
  end

  def game_round(game)
    description = @game.round.to_s
    description += ': ' + t("game.phase.civilization.#{@game.phase}") if @game.phase
    return description
  end

  def game_type_options
    Game::Civilization::AVAILABLE_TYPES.map do |type|
        [ game_type(type), type.to_s ]
    end
  end

  def game_max_time_options
    [10, 60, 0].map do |speed|
        [ game_speed(speed), speed ]
    end
  end

  def current_user_player(game = nil)
    game ||= @game
    return false unless game.is_a?(Game)
    return game.is_player?(current_user)
  end
end