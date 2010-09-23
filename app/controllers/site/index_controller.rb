class Site::IndexController < Site::DefaultController
  def index
    redirect_to "/site/games/index"
  end
end
