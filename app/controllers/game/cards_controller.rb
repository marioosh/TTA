class Game::CardsController < Game::DefaultController
  require_privilege Privilege::PLAY_GAMES
  before_filter :init_action, :except => :menu

  def menu
    @gc = GameCard.find(params[:id]) if params[:id]
    raise ActiveRecord::RecordNotFound, "Card ID has been not provided." if @gc.nil?

    @game = @gc.game
    if @game.player.user != current_user
      flash[:error] = 'Nieprawidłowa akcja.'
      redirect_to game_url(:id => @game)
    end

    respond_to do |type|
      type.html
      type.js
    end
  end

  def play
    redirect_to game_url(:id => @game)
  end

  def take
    redirect_to game_url(:id => @game)
  end

  def discard
    redirect_to game_url(:id => @game)
  end

  def build
    redirect_to game_url(:id => @game)
  end

  def upgrade
    redirect_to game_url(:id => @game)
  end

  def special
    redirect_to game_url(:id => @game)
  end

  def destroy
    redirect_to game_url(:id => @game)
  end

  def revolution
    redirect_to game_url(:id => @game)
  end

  def population
    redirect_to game_url(:id => @game)
  end

  def sacrifice
    redirect_to game_url(:id => @game)
  end

  private

  def init_action
    @gc = GameCard.find(params[:id]) if params[:id]
    raise ActiveRecord::RecordNotFound, "Card ID has been not provided." if @gc.nil?

    @game = @gc.game
    if @game.player.user != current_user
      flash[:error] = 'Nieprawidłowa akcja.'
      redirect_to game_url(:id => @game)
    else
      action = @gc.action!(params[:action], @game.player)
      @gc.game.current_action = action if action
      @gc.game.save
    end
  end
end