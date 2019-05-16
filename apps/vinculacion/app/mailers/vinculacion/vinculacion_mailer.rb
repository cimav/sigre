module Vinculacion
  class VinculacionMailer < ApplicationMailer

    def enviar_cotizacion(solicitud_id, cotizacion_id, current_email, msg_notificacion)

      @solicitud = Solicitud.find(solicitud_id)
      @cotizacion = Cotizacion.find(cotizacion_id)

      @from = "Servicio al cliente CIMAV <servicio.cliente@cimav.edu.mx>"
      @to = []
      @to << current_email
      @to << @solicitud.contacto.email

      @msg_notificacion = msg_notificacion


      @solicitud = Solicitud.find(solicitud_id)

      subject = "[CIMAV] Cotización #{@cotizacion.codigo}"
      filename = @cotizacion.solicitud.codigo.gsub('/','_').concat('.pdf')
      attachments[filename] = File.read(File.join(Rails.root.to_s, "private/cotizaciones", filename))

      mail(:to => @to, :from => @from, :reply_to => current_email,:subject => subject)
    end

    def servicios_alertados(alerta_id, mensaje, afectados)
      @from = "Servicio al cliente CIMAV <servicio.cliente@cimav.edu.mx>"
      @to = []

       # Usuarios de Servicios Vinculación
      @to << 'ion@cimav.edu.mx'
      @to << 'karen.valles@cimav.edu.mx'
      @to << 'ana.rodriguez@cimav.edu.mx'
      @to << 'salomon.maloof@cimav.edu.mx'
      @to << 'marisol.nevarez@cimav.edu.mx'

      @afectados = afectados
      @mensaje = mensaje

      subject = "[Vinculación] Alerta ##{alerta_id} #{usuarios_vinculacion}"
      mail(:to => @to, :from => @from, :subject => subject)
    end

    def alerta_resuelta(alerta_id)
      @from = "Servicio al cliente CIMAV <servicio.cliente@cimav.edu.mx>"
      @to = []

       # Usuarios de Servicios Vinculación
      @to << 'ion@cimav.edu.mx'
      @to << 'karen.valles@cimav.edu.mx'
      @to << 'ana.rodriguez@cimav.edu.mx'
      @to << 'salomon.maloof@cimav.edu.mx'
      @to << 'marisol.nevarez@cimav.edu.mx'

      @alerta_id = alerta_id
      #@to << 'karen.valles@cimav.edu.mx'

      subject = "[Vinculación] Alerta ##{alerta_id} Resuelta"
      mail(:to => @to, :from => @from, :subject => subject)
    end

    def encuesta_seguimiento(solicitud)

      # ::Vinculacion::VinculacionMailer.encuesta_seguimiento(cotizacion.solicitud).deliver

      # vista en encuesta_seguimiento.html.haml

      @solicitud = solicitud

      @from = "Servicio al cliente CIMAV <servicio.cliente@cimav.edu.mx>"
      @to = []
      @to << @solicitud.contacto.email
      @to << 'karen.valles@cimav.edu.mx'
      @to << 'juan.calderon@cimav.edu.mx'

      filename = solicitud.codigo.gsub('/','_').concat('.pdf')
      if File.exists?(filename)
        attachments[filename] = File.read(File.join(Rails.root.to_s, "private/cotizaciones", filename))
      end

      # https://docs.google.com/forms/d/e/1FAIpQLSe9kEYO9LgVdpboyRY4GOlUW-XhhTIORR4tdxvYvmrXjTI_5w/viewform?usp=pp_url&entry.1346649580=19/7777

      subject = "Encuesta de seguimiento de solicitud de servicio ##{@solicitud.codigo}"
      mail(:to => @to, :from => @from, :subject => subject)
    end
  end
end
