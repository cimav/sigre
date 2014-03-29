Vinculacion::Engine.routes.draw do
  resources :solicitudes 
  resources :muestras
  resources :servicios
  resources :servicios_muestras
  resources :clientes
  resources :contactos
  resources :proyectos
  resources :cotizaciones
  resources :cotizaciones_detalle

  post '/servicios/:id/solicitar_costeo', to: 'servicios#solicitar_costeo'

  resources :empleados

  root :to => 'assets#index'
  get "assets/index"
end
