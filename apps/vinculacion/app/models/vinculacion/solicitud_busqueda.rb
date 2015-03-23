module Vinculacion
  class SolicitudBusqueda < ActiveRecord::Base
    self.table_name = "vinculacion_solicitudes"

    has_many :muestras, :foreign_key => "solicitud_id", :class_name => "Muestra"
    has_many :servicios, :foreign_key => "solicitud_id", :class_name => "Servicio"
    has_many :cotizaciones, :foreign_key => "solicitud_id", :class_name => "Cotizacion"

    belongs_to  :proyecto
    belongs_to  :cliente
    belongs_to  :contacto
    belongs_to :usuario

    def status_text
      Solicitud::STATUS[status.to_i]
    end

    def cliente_razon_social
      self.cliente.razon_social rescue 'Sin cliente'
    end

    def contacto_nombre
      self.contacto.nombre rescue 'Sin contacto'
    end

    def proyecto_cuenta
      self.proyecto.cuenta rescue 'Proyecto sin cuenta'
    end

    def proyecto_nombre
      self.proyecto.nombre rescue 'Proyecto sin nombre'
    end

    def muestras_length
      self.muestras.count.to_s rescue '-'
    end

    def servicios_length
      self.servicios.count.to_s rescue '-'
    end

    def ultima_cotizacion
      self.cotizaciones.last.consecutivo rescue '-'
    end

    def datos_usuario
      self.usuario.usuario rescue 'sin usuario'
    end

  end
end
