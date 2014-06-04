Vinculacion::Engine.routes.draw do
  resources :solicitudes 
  resources :muestras
  resources :servicios
  resources :servicios_muestras
  resources :clientes
  resources :contactos
  resources :proyectos
  resources :cotizaciones
  resources :cotizaciones_detalle, path: 'cotizacion_detalle'
  post '/servicios/:id/solicitar_costeo', to: 'servicios#solicitar_costeo'

  resources :empleados
  resources :sedes
  resources :paises

  resources :costeos

  resources :solicitud_busqueda, :only => [:index]

  root :to => 'assets#index'
  get "assets/index"

  get "cotizacion/:id/:type" => 'cotizaciones#document' 
end
