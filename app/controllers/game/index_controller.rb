class Game::IndexController < Game::DefaultController
  def index
    @game = Game.find(params[:id]) if params[:id]

    if @game.nil?
      flash[:error] = 'Nieprawidłowy identyfikator - gra nie istnieje.'
      redirect_to root_url
    elsif @game.status == Game::Status::WAITING_FOR_PLAYERS
      redirect_to :controller => 'site/games', :action => :setup, :id => @game
    elsif @game.player.nil?
      render :action => 'blank'
    elsif current_user.nil? || @game.player.user != current_user
      render :action => 'waiting'
    else
      begin
        if (template = @game.main_loop(params, current_user))
          render :action => "game/phases/#{template}"
        else
          redirect_to game_url(:id => @game)
        end
      rescue Game::Error => e
        @game.current_action.destroy
        flash[:error] = e.message
        
        redirect_to game_url(:id => @game)
      end
    end
  end
end