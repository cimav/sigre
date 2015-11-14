require_dependency "vinculacion/application_controller"

module Vinculacion
  class SeguimientoController < ApplicationController
    def index
      if @solicitud = Solicitud.find_by_vinculacion_hash(params[:hash])
        @cotizacion = @solicitud.ultima_cotizacion
        queries = []
        queries << "SELECT activity_logs.created_at, message_type, requested_service_status AS status, message, CONCAT(first_name, ' ', last_name) AS name, email FROM bitacora_development.activity_logs LEFT JOIN bitacora_development.users ON user_id = users.id WHERE service_request_id IN (SELECT id FROM bitacora_development.service_requests WHERE number LIKE '#{@solicitud.codigo}%') ORDER BY activity_logs.created_at"
        queries << "SELECT vinculacion_solicitudes.created_at, 'SIGRE' AS message_type, 1 AS status, CONCAT('Se creo solicitud ', codigo) AS message, CONCAT(nombre, ' ', apellidos) AS name, email  FROM sigre_development.vinculacion_solicitudes LEFT JOIN sigre_development.usuarios ON usuario_id = usuarios.id WHERE vinculacion_solicitudes.id = #{@solicitud.id}"
        queries << "SELECT vinculacion_cotizaciones.created_at, 'SIGRE' AS message_type, 2 AS status, CONCAT('Se creo cotización ', vinculacion_solicitudes.codigo,'-',vinculacion_cotizaciones.consecutivo) AS message, CONCAT(nombre, ' ',apellidos) AS name, email FROM sigre_development.vinculacion_cotizaciones LEFT JOIN sigre_development.vinculacion_solicitudes ON solicitud_id = vinculacion_solicitudes.id  LEFT JOIN sigre_development.usuarios ON usuario_id = usuarios.id WHERE solicitud_id = #{@solicitud.id}"
        # Buscar mejor manera
        # queries << "SELECT vinculacion_cotizaciones.fecha_notificacion AS created_at, 'SIGRE' AS message_type, 3 AS status, CONCAT('Se envio cotización ', vinculacion_solicitudes.codigo,'-',vinculacion_cotizaciones.consecutivo,' a cliente') AS message, CONCAT(nombre, ' ',apellidos) AS name, email FROM sigre_development.vinculacion_cotizaciones LEFT JOIN sigre_development.vinculacion_solicitudes ON solicitud_id = vinculacion_solicitudes.id  LEFT JOIN sigre_development.usuarios ON usuario_id = usuarios.id WHERE solicitud_id = #{@solicitud.id}"
        queries << "SELECT vinculacion_cotizaciones.updated_at AS created_at, 'SIGRE' AS message_type, vinculacion_cotizaciones.status AS status, CONCAT('Cotización ', vinculacion_solicitudes.codigo,'-',vinculacion_cotizaciones.consecutivo,' aceptada por cliente') AS message, CONCAT(nombre, ' ',apellidos) AS name, email FROM sigre_development.vinculacion_cotizaciones LEFT JOIN sigre_development.vinculacion_solicitudes ON solicitud_id = vinculacion_solicitudes.id  LEFT JOIN sigre_development.usuarios ON usuario_id = usuarios.id WHERE solicitud_id = #{@solicitud.id} AND vinculacion_cotizaciones.status = 3"
        queries << "SELECT vinculacion_cotizaciones.updated_at AS created_at, 'SIGRE' AS message_type, vinculacion_cotizaciones.status AS status, CONCAT('Cotización ', vinculacion_solicitudes.codigo,'-',vinculacion_cotizaciones.consecutivo,' rechazada por cliente') AS message, CONCAT(nombre, ' ',apellidos) AS name, email FROM sigre_development.vinculacion_cotizaciones LEFT JOIN sigre_development.vinculacion_solicitudes ON solicitud_id = vinculacion_solicitudes.id  LEFT JOIN sigre_development.usuarios ON usuario_id = usuarios.id WHERE solicitud_id = #{@solicitud.id} AND vinculacion_cotizaciones.status = 4"
        # Buscar mejor manera de sacar la fecha de arrancada
        # queries << "SELECT fecha_inicio AS created_at, 'SIGRE' AS message_type, vinculacion_solicitudes.status, 'Solicitud arrancada' AS message, CONCAT(nombre, ' ',apellidos) AS name, email FROM sigre_development.vinculacion_solicitudes LEFT JOIN sigre_development.usuarios ON usuario_id = usuarios.id WHERE vinculacion_solicitudes.id = #{@solicitud.id} AND vinculacion_solicitudes.status IN (4,5)"
        queries << "SELECT vinculacion_solicitudes.updated_at AS created_at, 'SIGRE' AS message_type, vinculacion_solicitudes.status, 'Solicitud finalizada' AS message, CONCAT(nombre, ' ',apellidos) AS name, email FROM sigre_development.vinculacion_solicitudes LEFT JOIN sigre_development.usuarios ON usuario_id = usuarios.id WHERE vinculacion_solicitudes.id = #{@solicitud.id} AND vinculacion_solicitudes.status = 5"
        queries << "SELECT vinculacion_solicitudes.updated_at AS created_at, 'SIGRE' AS message_type, vinculacion_solicitudes.status, 'Solicitud cancelada' AS message, CONCAT(nombre, ' ',apellidos) AS name, email FROM sigre_development.vinculacion_solicitudes LEFT JOIN sigre_development.usuarios ON usuario_id = usuarios.id WHERE vinculacion_solicitudes.id = #{@solicitud.id} AND vinculacion_solicitudes.status = 99"
        

        @logs = {}
        queries.each do |q|
          puts "--------------------"
          puts q
          items = Solicitud.find_by_sql q
          items.each do |i|
            item = {}
            item['created_at'] = i.created_at
            item['message_type'] = i.message_type
            item['status'] = i.status
            item['message'] = i.message
            item['name'] = i.name
            item['email'] = i.email
            puts i.message
            if @logs["#{i['created_at']}"] 
              @logs["#{i['created_at']}.0"] = item
            else
              @logs["#{i['created_at']}"] = item
            end
          end
        end

        @logs = @logs.sort.to_h

      else
        render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found 
      end
    end
  end
end
