Proyectos::Engine.routes.draw do

  resources :monedas
  resources :tipos
  resources :recursos
  resources :fondos
  resources :proyectos

  # de RH
  resources :empleados
  resources :sedes
  resources :departamentos

  resources :proyecto_busqueda, :only => [:index]

  root :to => 'assets#index'
  get "assets/index"

end

