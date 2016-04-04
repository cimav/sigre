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
  resources :servicios_bitacora
  resources :laboratorios_bitacora
  resources :clientes_netmultix, path: 'cliente_netmultix'
  post '/servicios/:id/solicitar_costeo', to: 'servicios#solicitar_costeo'
  post '/servicios/:id/cancelar', to: 'servicios#cancelar'
  post '/solicitudes/:id/notificar_cancelacion', to: 'solicitudes#notificar_cancelacion'
  post '/solicitudes/:id/notificar_arranque', to: 'solicitudes#notificar_arranque'
  post '/solicitudes/:id/notificar_arranque_no_coordinado', to: 'solicitudes#notificar_arranque_no_coordinado'
  post '/solicitudes/:id/notificar_arranque_tipo_2', to: 'solicitudes#notificar_arranque_tipo_2'
  get '/solicitudes/:id/estado_actual', to: 'solicitudes#estado_actual'


  resources :empleados
  resources :sedes
  resources :paises
  resources :estados

  resources :costeos

  resources :solicitud_busqueda, :only => [:index]

  resources :costos_variables
  resources :remanentes
  resources :cedulas

  resources :usuarios

  resources :muestras_detalle #, path: 'muestra_detalle'

  root :to => 'assets#index'
  get "assets/index"
  get '/seguimiento/:hash' => 'seguimiento#index'

  get "cotizacion/:id/:type" => 'cotizaciones#document' 
  get "descargar/cotizacion/:vinculacion_hash" => 'cotizaciones#download_document' 
  get "estimacion_costos/:id" => 'solicitudes#estimacion_costos' 
  get "recepcion_muestras/:id" => 'solicitudes#recepcion_muestras' 
end
