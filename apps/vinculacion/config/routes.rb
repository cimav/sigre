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
  post '/solicitudes/:id/cancelar_solicitud', to: 'solicitudes#cancelar_solicitud'

  resources :empleados
  resources :sedes
  resources :paises
  resources :estados

  resources :costeos

  resources :solicitud_busqueda, :only => [:index]

  root :to => 'assets#index'
  get "assets/index"

  get "cotizacion/:id/:type" => 'cotizaciones#document' 
end
