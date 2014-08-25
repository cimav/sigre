Proyectos::Engine.routes.draw do

  resources :tipos
  resources :recursos
  resources :fondos
  resources :proyectos

  root :to => 'assets#index'
  get "assets/index"

end
