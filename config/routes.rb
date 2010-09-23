TTA::Application.routes.draw do |map|
  root :to => "site/games#index"
  match 'login' => redirect('/site/security/login')
  match 'admin' => 'admin/index#index'
  match 'game/:id' => 'game/index#index', :id => /\d+/, :as => :game
  match ':controller(/:action(/:id))', :id => /\d+/
end