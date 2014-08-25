Proyectos::Engine.routes.draw do

  resources :tipos
  resources :recursos
  resources :fondos
  resources :proyectos

  resources :proyectos_busqueda, :only => [:index]

  root :to => 'assets#index'
  get "assets/index"

end
