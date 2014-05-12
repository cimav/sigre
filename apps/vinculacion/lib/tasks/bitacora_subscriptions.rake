require 'resque-bus'
class BitacoraSubscriptions
  include ResqueBus::Subscriber

  subscribe :recibir_costeo

  def recibir_costeo(attributes)

    attributes['servicios'].each do |s|

      puts "Recibir costeo #{s['bitacora_id']}: #{s['nombre_servicio']}"

      costeo = ::Vinculacion::Costeo.new
      costeo.bitacora_id     = s['bitacora_id']
      costeo.servicio_id     = attributes['system_id']
      costeo.muestra_id      = s['muestra_system_id']
      costeo.nombre_servicio = s['nombre_servicio'] 
      costeo.save

      # PERSONAL
      s['personal'].each do |p|
        puts "Agregando #{p['detalle']}"
        item = costeo.costeo_detalle.new
        item.tipo = 1
        item.descripcion     = p['detalle']
        item.cantidad        = p['cantidad']
        item.precio_unitario = p['precio_unitario']
        item.save
      end

      # EQUIPO
      s['equipos'].each do |p|
        puts "Agregando #{p['detalle']}"
        item = costeo.costeo_detalle.new
        item.tipo = 2
        item.descripcion     = p['detalle']
        item.cantidad        = p['cantidad']
        item.precio_unitario = p['precio_unitario']
        item.save
      end

      # CONSUMIBLES
      s['consumibles'].each do |p|
        puts "Agregando #{p['detalle']}"
        item = costeo.costeo_detalle.new
        item.tipo = 3
        item.descripcion     = p['detalle']
        item.cantidad        = p['cantidad']
        item.precio_unitario = p['precio_unitario']
        item.save
      end

      # OTROS
      s['otros'].each do |p|
        puts "Agregando #{p['detalle']}"
        item = costeo.costeo_detalle.new
        item.tipo = 4
        item.descripcion     = p['detalle']
        item.cantidad        = p['cantidad']
        item.precio_unitario = p['precio_unitario']
        item.save
      end
    end

    servicio = ::Vinculacion::Servicio.find(attributes['system_id'])
    servicio.status = ::Vinculacion::Servicio::ESPERANDO_ARRANQUE
    servicio.save

  end
end
