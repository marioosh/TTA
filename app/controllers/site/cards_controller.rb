class Site::CardsController < Site::DefaultController
  def show
    @card = Card.find(params[:id]) if params[:id]
  end
end
