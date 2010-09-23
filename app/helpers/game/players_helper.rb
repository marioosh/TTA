module Game::PlayersHelper
  def show_actions(player)
    html = ''
    (1..player.military_actions_left).each do |i|
      html << image_tag('game/icon_red.png', :style => "position: absolute; right: #{i*10-10}px; top: 0; width: 30px;")
    end

    (1..player.civil_actions_left).each do |i|
      html << image_tag('game/icon_white.png', :style => "position: absolute; right: #{(player.military_actions_left+i)*10+10}px; top: 0; width: 30px;")
    end

    return content_tag(:div, html.html_safe, :class => 'actions', :style => 'z-index: 100')
  end

  def blue_tokens_bank(player)
    bank = (1..player.blue_tokens_available).map do |i|
      offset = 11 if i > 8
      offset = 7 if i <= 8
      offset = 2 if i <= 4

      j = (i-1)/2
      if (i % 2 == 1)
        y = 35
        x = offset +25*j
      else
        y = 5
        x = offset +25*j
      end
      image_tag 'game/icon_blue.png', :alt => "Blue token \##{i}", :style => "position: absolute; left: #{x}px; top: #{y}px; width: 30px;"
    end

    return bank.join.html_safe
  end

  def yellow_tokens_bank(player)
    bank = (1..player.yellow_tokens_available).map do |i|
      offset = 2

      j = (i-1)/2
      if (i % 2 == 1)
        y = 60
        x = offset +33.5*j
      else
        y = 25
        x = offset +33.5*j
      end
      image_tag 'game/icon_yellow.png', :alt => "Yellow token \##{i}", :style => "position: absolute; left: #{x}px; top: #{y}px; width: 30px;"
    end

    return bank.join.html_safe
  end

  def happiness_level(player)
    html = []
    
    smileys = [ 96, 130, 180, 230, 265, 298, 332, 365, 400 ]
    html << image_tag('game/icon_blue.png', :style => "position: absolute; right: #{smileys[player.happiness]}px; top: 0; width: 30px;")
    player.happiness_workers.times do |i|
      html << image_tag('game/icon_yellow.png', :style => "position: absolute; right: #{smileys[player.happiness + i + 1]}px; top: 0; width: 30px;")
    end

#    (1..player.happiness_workers).each do |i|
#      html << image_tag('game/icon_yellow.png', :style => "position: absolute; right: #{i*50+80}px; top: 0; width: 30px;")
#    end

    return content_tag(:div, html.join.html_safe, :class => 'happiness', :style => 'z-index: 100')
  end
end