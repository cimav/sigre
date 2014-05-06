module Vinculacion
  class SolicitudBusqueda < ActiveRecord::Base
    self.table_name = "vinculacion_solicitudes"
    has_many :muestras
    has_many :servicios
    has_many :cotizaciones

    belongs_to   :sede
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

  end
end
