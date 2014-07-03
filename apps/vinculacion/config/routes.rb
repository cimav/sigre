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
  post '/solicitudes/:id/notificar_cancelacion', to: 'solicitudes#notificar_cancelacion'
  post '/solicitudes/:id/notificar_arranque', to: 'solicitudes#notificar_arranque'

  resources :empleados
  resources :sedes
  resources :paises
  resources :estados

  resources :costeos

  resources :solicitud_busqueda, :only => [:index]

  resources :costos_variables
  resources :remanentes
  resources :cedulas

  root :to => 'assets#index'
  get "assets/index"

  get "cotizacion/:id/:type" => 'cotizaciones#document' 
end
