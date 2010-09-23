class Site::GamesController < Site::DefaultController
  before_filter :init_game, :except => [ :index, :create ]
  require_privilege Privilege::PLAY_GAMES, :only => [ :create, :delete, :join, :chat, :start ]

  def index
    @filter = GameFilter.new((params[:filter] || session[:filter] || {}).merge({ :exclude_user => current_user }))
    session[:filter] = params[:filter] if request.post? && params[:filter]
  end

  def create
    @game = Game.new(:user => current_user)

    if request.post? && params[:game]
      @game.type = params[:game][:type]
      @game.update_attributes!(params[:game])

      if @game.valid?
        @game.join_player(current_user)

        @game.game_events.create(:user => current_user, :description => "Gra została utworzona.")
        redirect_to :action => :setup, :id => @game
      end
    end
  end
  
  def delete
    if @game.user != current_user
      flash[:error] = 'Tylko założyciel gry może ją zakończyć.'
      redirect_to :action => :setup, :id => @game
    elsif @game.status != Game::Status::WAITING_FOR_PLAYERS
      flash[:error] = 'Nie możesz przerwać już rozpoczętych gier.'
      redirect_to :action => :show, :id => @game
    else
      @game.abort!

      flash[:success] = 'Gra została zakończona.'
      redirect_to :action => :index
    end
  end

  def setup
    if @game.status != Game::Status::WAITING_FOR_PLAYERS
      # if game's not in config state anymore - maybe it's already playable?
      redirect_to :action => :show, :id => @game
    end
  end

  def events
    render :layout => 'site/blank'
  end

  def chat
    unless params[:chat].nil? || params[:chat][:message].nil? || params[:chat][:message].empty?
      @game.game_events.create(:user => current_user, :description => params[:chat][:message])
    end

    redirect_to :action => :show, :id => @game
  end

  def start
    begin
      @game.start_game(current_user)
      flash[:success] = 'Gra została rozpoczęta!'
    rescue Game::Error => e
      flash[:error] = e.message
    end

    redirect_to :action => :show, :id => @game
  end

  def show
    redirect_to game_url(:id => @game)
  end

  def join
    pwd = params[:game] ? params[:game][:password] : ''
    begin
      flash[:success] = 'Dołączyłeś do gry.' if @game.join_player(current_user, pwd)
    rescue Game::Error => e
      flash[:error] = e.message
    end

    redirect_to :action => :show, :id => @game
  end

  private

  def init_game
    @game = Game.find(params[:id]) if params[:id]

    if @game.nil?
      flash[:error] = 'Nieprawidłowy identyfikator - gra nie istnieje.'
      redirect_to :action => :index
    end
  end
end