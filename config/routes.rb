require 'resque/server'
Sigre::Application.routes.draw do

  root :to => 'home#index'

  match '/auth/:provider/callback' => 'sessions#create', via: [:get, :post]
  match '/auth/failure' => 'sessions#failure', via: [:get, :post]
  match "/logout" => 'sessions#destroy', via: [:get, :post]
  match '/login' => 'login#index', via: [:get, :post]

  mount Resque::Server.new, :at => '/resque'
  mount Rh::Engine => '/rh', as: 'rh'
  mount Vinculacion::Engine => '/vinculacion', as: 'vinculacion'
  mount Proyectos::Engine => '/proyectos', as: 'proyectos'
end
