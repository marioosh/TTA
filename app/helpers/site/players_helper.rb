module Site::PlayersHelper
  def show_color(value)
    value = value.color if value.is_a? Player
    
    case value
    when Player::Color::NONE
      return '#ccc'
    when Player::Color::RED
      return '#c00'
    when Player::Color::GREEN
      return '#0c0'
    when Player::Color::BLUE
      return '#00c'
    when Player::Color::YELLOW
      return '#cc0'
    else
      return '#ccc'
    end
  end

  def available_colors_options(player)
    colors = player.available_colors.map do |color|
      [ t("player.color.#{color}"), color ]
    end

    return [['- wybierz kolor -', Player::Color::NONE]] + colors
  end
end