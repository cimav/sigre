Sigre::Application.routes.draw do
  mount Rh::Engine => '/rh', as: 'rh'
end
