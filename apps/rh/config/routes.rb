Rh::Engine.routes.draw do
  resources :empleados
  resources :departamentos
  resources :sedes

  root :to => 'assets#index'
  get "assets/index"
end
