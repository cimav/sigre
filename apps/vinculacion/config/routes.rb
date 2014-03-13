Vinculacion::Engine.routes.draw do
  resources :solicitudes
  resources :clientes

  root :to => 'assets#index'
  get "assets/index"
end
