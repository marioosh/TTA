class Site::PlayersController < Site::DefaultController
  require_privilege Privilege::PLAY_GAMES

  def color
    @player = Player.find(params[:id]) if params[:id]
    @game = @player.game

    begin
      raise Player::Error::NotPermitted, "Tylko założyciel gry lub dany użytkownik może zmieniać kolor." unless @game.user == current_user || @player.user == current_user
      if params[:player]
        # dirty hack - otherwise @player does not update @game.players
        @player = @game.players.find(@player.id)
        @player.color = params[:player][:color]
        @player.save
      end
    rescue Player::Error => e
      flash[:error] = e.message
    end

    #render :text => 'test'
    #redirect_to "/site/games/setup/#{@game.id}" unless request.xhr?
    
    render :partial => 'site/games/players_colors', :layout => false if request.xhr?
  end

  def remove
    @player = Player.find(params[:id]) if params[:id]
    if @player.nil?
      redirect_to root_url
    else
      @game = @player.game
      if @game.status == Game::Status::WAITING_FOR_PLAYERS
        if @game.user == current_user
          if @game.user != @player.user
            message = "Gracz #{@player.user.profile.name} został usunięty z rozgrywki."
            @game.game_events.create(:description => message)
            flash[:notice] = message
            @player.destroy
          else
            flash[:error] = 'Jako założyciel gry, nie możesz opuścić rozgrywki.'
          end
        else
          if @player.user == current_user
            @game.game_events.create(:description => "Użytkownik #{@player.user.profile.name} opuścił rozgrywkę.")
            flash[:notice] = 'Opuściłeś rozgrywkę.'
            @player.destroy
          else
            flash[:error] = 'Tylko założyciel gry może usuwać innych graczy z rozgrywki.'
          end
        end
      else
        flash[:error] = 'Gra już się rozpoczęła, nie można usuwać graczy w jej trakcie.'
      end
    end

    redirect_to "/site/games/setup/#{@game.id}"
  end
end