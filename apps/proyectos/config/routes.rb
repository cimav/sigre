Proyectos::Engine.routes.draw do

  resources :tipos
  resources :recursos

  root :to => 'assets#index'
  get "assets/index"

end
