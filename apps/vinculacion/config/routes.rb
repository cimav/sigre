Vinculacion::Engine.routes.draw do
  resources :solicitudes
  resources :muestras
  resources :clientes

  root :to => 'assets#index'
  get "assets/index"
end
