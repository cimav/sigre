require 'resque-bus'
# FIXME: Usar constantes en lugar de números mágicos
class BitacoraSubscriptions
  include QueueBus::Subscriber

  subscribe :recibir_costeo
  subscribe :recibir_reporte

  def recibir_costeo(attributes)

    puts "SIGRE: RECIBIR COSTEO"

    attributes['servicios'].each do |s|


      costeo = ::Vinculacion::Costeo.new
      costeo.bitacora_id     = s['bitacora_id']
      costeo.servicio_id     = attributes['system_id']
      costeo.muestra_id      = s['muestra_system_id']
      costeo.nombre_servicio = s['nombre_servicio'] 
      costeo.save

      # PERSONAL
      s['personal'].each do |p|
        item = costeo.costeo_detalle.new
        item.tipo = 1
        item.descripcion     = p['detalle']
        item.cantidad        = p['cantidad']
        item.precio_unitario = p['precio_unitario']
        item.save
      end

      # EQUIPO
      s['equipos'].each do |p|
        item = costeo.costeo_detalle.new
        item.tipo = 2
        item.descripcion     = p['detalle']
        item.cantidad        = p['cantidad']
        item.precio_unitario = p['precio_unitario']
        item.save
      end

      # OTROS
      s['otros'].each do |p|
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


  def recibir_reporte(attributes)

    puts "SIGRE: RECIBIR REPORTE"

    cedula = ::Vinculacion::Cedula.where(:solicitud_id => attributes['system_request_id'], :servicio_id => attributes['system_id']).first
    attributes['participaciones'].each do |p|
      if empleado = ::Vinculacion::Empleado.where(:email => p['email']).first
        remanente = cedula.remanentes.new
        remanente.porcentaje_participacion = p['porcentaje']
        remanente.empleado_id = empleado.id
        remanente.save
      else
        puts "Error: Empleado no existe"
      end
    end

    attributes['servicios'].each do |s|


      # PERSONAL
      s['personal'].each do |p|
        item = cedula.costo_variable.new
        item.tipo = 1 
        if p['cantidad'].to_f > 1
          item.descripcion = "#{p['detalle']} (x#{p['cantidad']})"
        else   
          item.descripcion = p['detalle'] 
        end        
        item.costo        = p['cantidad'].to_f * p['precio_unitario'].to_f
        item.save
      end

      # EQUIPO
      s['equipos'].each do |p|
        item = cedula.costo_variable.new
        item.tipo = 2 
        if p['cantidad'].to_f > 1
          item.descripcion = "#{p['detalle']} (x#{p['cantidad']})"
        else   
          item.descripcion = p['detalle'] 
        end        
        item.costo        = p['cantidad'].to_f * p['precio_unitario'].to_f
        item.save
      end

      # # CONSUMIBLES
      # s['consumibles'].each do |p|
      #   puts "Agregando #{p['detalle']}"
      #   item = cedula.costo_variable.new
      #   item.tipo = 3 
      #   if p['cantidad'].to_f > 1
      #     item.descripcion = "#{p['detalle']} (x#{p['cantidad']})"
      #   else   
      #     item.descripcion = p['detalle'] 
      #   end      
      #   item.costo = p['cantidad'].to_f * p['precio_unitario'].to_f
      #   item.save
      # end

      # OTROS
      s['otros'].each do |p|
        item = cedula.costo_variable.new
        item.tipo = 4 
        if p['cantidad'].to_f > 1
          item.descripcion = "#{p['detalle']} (x#{p['cantidad']})"
        else   
          item.descripcion = p['detalle'] 
        end        
        item.costo = p['cantidad'].to_f * p['precio_unitario'].to_f
        item.save
      end
    end

    servicio = ::Vinculacion::Servicio.find(attributes['system_id'])
    servicio.status = ::Vinculacion::Servicio::FINALIZADO
    servicio.save
     

  end
end
