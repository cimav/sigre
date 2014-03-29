require 'resque-bus'
class BitacoraSubscriptions
  include ResqueBus::Subscriber

  subscribe :recibir_costeo

  def recibir_costeo(attributes)

    puts "Recibir costeo #{attributes['bitacora_id']}: #{attributes['nombre_servicio']}"

    costeo = ::Vinculacion::Costeo.new
    costeo.bitacora_id     = attributes['bitacora_id']
    costeo.servicio_id     = attributes['system_id']
    costeo.muestra_id      = attributes['muestra_system_id']
    costeo.nombre_servicio = attributes['nombre_servicio'] 
    costeo.save

    # PERSONAL
    attributes['personal'].each do |p|
      puts "Agregando #{p['detalle']}"
      item = costeo.costeo_detalle.new
      item.tipo = 1
      item.descripcion     = p['detalle']
      item.cantidad        = p['cantidad']
      item.precio_unitario = p['precio_unitario']
      item.save
    end

    # EQUIPO
    attributes['equipos'].each do |p|
      puts "Agregando #{p['detalle']}"
      item = costeo.costeo_detalle.new
      item.tipo = 2
      item.descripcion     = p['detalle']
      item.cantidad        = p['cantidad']
      item.precio_unitario = p['precio_unitario']
      item.save
    end

    # CONSUMIBLES
    attributes['consumibles'].each do |p|
      puts "Agregando #{p['detalle']}"
      item = costeo.costeo_detalle.new
      item.tipo = 3
      item.descripcion     = p['detalle']
      item.cantidad        = p['cantidad']
      item.precio_unitario = p['precio_unitario']
      item.save
    end

    # OTROS
    attributes['otros'].each do |p|
      puts "Agregando #{p['detalle']}"
      item = costeo.costeo_detalle.new
      item.tipo = 4
      item.descripcion     = p['detalle']
      item.cantidad        = p['cantidad']
      item.precio_unitario = p['precio_unitario']
      item.save
    end
    
    puts "--------------------------------------"

  end
end
