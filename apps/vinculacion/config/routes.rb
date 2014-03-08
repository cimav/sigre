Vinculacion::Engine.routes.draw do
  resources :solicitudes

  root :to => 'assets#index'
  get "assets/index"
end
