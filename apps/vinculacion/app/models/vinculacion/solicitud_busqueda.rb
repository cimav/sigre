module Vinculacion
  class SolicitudBusqueda < ActiveRecord::Base
    self.table_name = "vinculacion_solicitudes"

    belongs_to  :proyecto
    belongs_to  :cliente
    belongs_to  :contacto

    def cliente_razon_social
      self.cliente.razon_social rescue 'Sin cliente'
    end

    def contacto_nombre
      self.contacto.nombre rescue 'Sin contacto'
    end

    def proyecto_codigo
      self.proyecto.codigo rescue 'Sin proyecto'
    end

    def proyecto_nombre
      self.proyecto.nombre rescue '--'
    end

     def muestras_length
       muestras = Muestra.where(:solicitud_id => self.id)
       muestras.count.to_s rescue '-'
     end

    def servicios_length
      servicios = Servicio.where(:solicitud_id => self.id)
      servicios.count.to_s rescue '-'
    end

    def ultima_cotizacion
      cotizaciones = Cotizacion.where(:solicitud_id => self.id)
      cotizaciones.last.consecutivo rescue '-'
    end

  end
end
