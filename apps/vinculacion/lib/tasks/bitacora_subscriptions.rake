require 'resque-bus'
# FIXME: Usar constantes en lugar de números mágicos
class BitacoraSubscriptions
  include QueueBus::Subscriber

  subscribe :recibir_costeo
  subscribe :recibir_reporte
  subscribe :recibir_reporte_tipo_2
  subscribe :recibir_alerta
  subscribe :resolver_alerta


  def recibir_alerta(attributes)
    afectados = []
    empleado = ::Vinculacion::Empleado.where(:email => attributes['email']).first
    attributes['lista'].each do |i|
      Vinculacion::Servicio.joins(:servicio_bitacora, :solicitud).where("bitacora_id = #{i} AND vinculacion_solicitudes.status < #{::Vinculacion::Solicitud::STATUS_FINALIZADA}").each do |a|
        afectados << a
        registro = Vinculacion::Registro.new
        registro.empleado_id = empleado.id
        registro.bitacora_alerta_id = attributes['alerta_id']
        registro.fecha_apertura = attributes['fecha_apertura']
        registro.solicitud_id = a.solicitud_id
        registro.tipo = ::Vinculacion::Registro::TIPO_ALERTA
        registro.status = ::Vinculacion::Registro::STATUS_ALERTA_ABIERTA
        registro.mensaje = "[ALERTA #{attributes['alerta_id']}]\nServicio: #{a.codigo} \n#{attributes['mensaje']}"
        registro.save
      end
    end
    Resque.enqueue(ServiciosAlertadosMailer, attributes['alerta_id'], attributes['mensaje'], afectados)
  end

  def resolver_alerta(attributes)
    empleado = ::Vinculacion::Empleado.where(:email => attributes['email']).first
    alertas = Vinculacion::Registro.where(:bitacora_alerta_id => attributes['alerta_id'])
    alertas.each do |a|
      a.fecha_cierre = attributes['fecha_cierre']
      a.empleado_cierre_id = empleado.id
      a.status = ::Vinculacion::Registro::STATUS_ALERTA_CERRADA
      a.save
    end
    Resque.enqueue(AlertaResueltaMailer, attributes['alerta_id'])
  end

  def recibir_costeo(attributes)

    Rails.logger.debug "SIGRE: RECIBIR COSTEO"

    attributes['servicios'].each do |s|

      costeo = ::Vinculacion::Costeo.new
      costeo.bitacora_id     = s['bitacora_id']
      costeo.servicio_id     = attributes['system_id']
      costeo.muestra_id      = s['muestra_system_id']
      costeo.nombre_servicio = s['nombre_servicio']
      costeo.leyenda         = s['legend']
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
    servicio.precio_sugerido = attributes['precio_sugerido']
    servicio.tiempo_estimado = attributes['tiempo_estimado']
    servicio.status = ::Vinculacion::Servicio::ESPERANDO_ARRANQUE

    servicio.save

  end


  def recibir_reporte(attributes)

    Rails.logger.debug "SIGRE: RECIBIR REPORTE"

    puts "---------------------------------------------------"
    puts "RECIBE REPORTE #{attributes['system_id']}"


    cedula = ::Vinculacion::Cedula.where(:solicitud_id => attributes['system_request_id'], :servicio_id => attributes['system_id']).first
    attributes['participaciones'].each do |p|
      puts "EMPLEADO #{p['email']}"
      if empleado = ::Vinculacion::Empleado.where(:email => p['email']).first
        remanente = cedula.remanentes.new
        remanente.porcentaje_participacion = p['porcentaje']
        remanente.empleado_id = empleado.id
        if remanente.save
          puts "REMANENTE GUARDADO"
        else
          puts "ERROR EN REMANENTE"
        end
      else
        Rails.logger.debug "Error: Empleado no existe"
        puts "EMPLEADO NO EXISTE"
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
        if item.save
          puts "GUARDO PERSONAL #{p['detalle']} "
        else
          put "ERROR EN PERSONAL"
        end
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

        if item.save
          puts "GUARDO EQUIPO #{p['detalle']}"
        else
          put "ERROR EN EQUIPO"
        end
      end

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
        if item.save
          puts "GUARDO OTRO: #{p['detalle']}"
        else
          put "ERROR EN OTRO"
        end
      end
    end


    servicio = ::Vinculacion::Servicio.find(attributes['system_id'])
    servicio.status = ::Vinculacion::Servicio::FINALIZADO
    if servicio.save
      puts "GRABO SERVICIO"
    else
      puts "ERROR AL GRABAR SERVICIO"
    end



  end


  def recibir_reporte_tipo_2(attributes)

    Rails.logger.debug "SIGRE: RECIBIR REPORTE TIPO 2 v2"

    cedula_first = ::Vinculacion::Cedula.where(:solicitud_id => attributes['system_request_id']).first

    attributes['servicios'].each do |s|


      # PERSONAL
      s['personal'].each do |p|
        cedula = ::Vinculacion::Cedula.where(:id =>  p['cedula']).first
        cedula = cedula_first if !cedula

        item = cedula.costo_variable.new
        item.tipo = 1
        if p['cantidad'].to_f > 1
          item.descripcion = "#{p['detalle']} (x#{p['cantidad']})"
        else
          item.descripcion = p['detalle']
        end
        item.costo        = p['cantidad'].to_f * p['precio_unitario'].to_f

        # Remanente
        if empleado = ::Vinculacion::Empleado.where(:email => p['email']).first
          remanente = cedula.remanentes.new
          remanente.porcentaje_participacion = p['porcentaje']
          remanente.empleado_id = empleado.id
          remanente.save
        end

        puts "ITEM #{item}"
        item.save
      end

      # EQUIPO
      s['equipos'].each do |p|
        
        cedula = ::Vinculacion::Cedula.where(:id =>  p['cedula']).first
        cedula = cedula_first if !cedula

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

      # OTROS
      s['otros'].each do |p|

        cedula = ::Vinculacion::Cedula.where(:id =>  p['cedula']).first
        cedula = cedula_first if !cedula

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


    servicios = ::Vinculacion::Servicio.where(:solicitud_id => attributes['system_request_id'])
    servicios.each do |servicio|
      servicio.status = ::Vinculacion::Servicio::FINALIZADO
      servicio.save
    end


  end

end
