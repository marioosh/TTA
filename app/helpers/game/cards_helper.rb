module Game::CardsHelper
  def add_card_breadcrumb(card)
    add_breadcrumb 'Cywilizacjopedia'
    add_breadcrumb 'Karty cywilne' if card.is_a? Card::Civil
    add_breadcrumb 'Karty militarne' if card.is_a? Card::Military
    add_breadcrumb card_title(card)
  end

  def card_title(card)
    "#{card.name} (#{card_age(card)})"
  end

  def card_age(card)
    return 'A' if card.age == 0
    return 'I' if card.age == 1
    return 'II' if card.age == 2
    return 'III' if card.age == 3
    return 'IV' if card.age == 4
  end

  def card_hint(card)
    hint = "#{card.name} (#{card_age(card)})"
    hint << " - #{card.description}" unless card.description.nil? || card.description.length < 5
    return hint
  end

  def card_back(card)
    prefix = card.is_a?(Card::Civil) ? 'civil' : 'military'
    return image_tag("cards/#{card_age(card)}/#{prefix}-back-mini.png", :alt => card_age(card))
  end

  def show_card(card, version = :mini)
    return image_tag(card.image.send(version).url, :alt => card_title(card), :title => card_hint(card)) if card.is_a? Card

    if card.is_a? GameCard
      if card.is_a?(GameCard::PlayerHand) && (current_user != card.player.user)
        return card_back(card.card)
      else
        img = image_tag(card.card.image.send(version).url, :alt => card_title(card.card), :title => card_hint(card.card))
        return img unless card.game.player.user == current_user && !card.menu_options.empty?

        return link_to(img, "/game/cards/menu/#{card.id}", :remote => true).html_safe
#           { :url => { :controller => 'game/index', :action => 'card', :id => card.game, :gc => card },
#             :update => "current-card", :complete => "card_menu(true)" },
#           :href => url_for( :controller => 'game/index', :action => 'card', :id => card.game, :gc => card ))
      end
    end
  end

  # PlayerAction::Military::DiscardCard
  # PlayerAction::Military::DiscardCard.new
  # "PlayerAction::Military::DiscardCard"
  # "Military::DiscardCard"
  #               -> t('player_action.military.discard_card')
  def show_player_action(pa)
    pa = case pa
    when PlayerAction then pa.class.to_s
    when Class then pa.to_s
    when String then pa[/PlayerAction::.*/] ? pa : "PlayerAction::#{pa}"
    end

    t(pa.underscore.gsub('/', '.'))
  end
end