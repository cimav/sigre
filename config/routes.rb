require 'resque/server'
Sigre::Application.routes.draw do
  mount Resque::Server.new, :at => '/resque'
  mount Rh::Engine => '/rh', as: 'rh'
  mount Vinculacion::Engine => '/vinculacion', as: 'vinculacion'
end
