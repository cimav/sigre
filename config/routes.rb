Sigre::Application.routes.draw do
  mount Rh::Engine => '/rh', as: 'rh'
  mount Vinculacion::Engine => '/vinculacion', as: 'vinculacion'
end
