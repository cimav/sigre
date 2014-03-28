# coding: utf-8
module Vinculacion
  class Servicio < ActiveRecord::Base
    belongs_to :solicitud
    belongs_to :empleado
    has_and_belongs_to_many :muestras, :join_table => :vinculacion_servicios_muestras

    after_create :set_extra

    INICIAL          = 1
    ESPERANDO_COSTEO = 2
    EN_COTIZACION    = 3
    EN_PROCESO       = 4
    FINALIZADO       = 5
    CANCELADO        = 99

    STATUS = {
      INICIAL          => 'Inicio',
      ESPERANDO_COSTEO => 'Esperando costeo',
      EN_COTIZACION    => 'En cotización',
      EN_PROCESO       => 'En proceso',
      FINALIZADO       => 'Finalizado',
      CANCELADO        => 'Cancelado',
    }

    def status_text
      STATUS[status.to_i]
    end

    def set_extra
      con = Servicio.where(:solicitud_id => self.solicitud_id).maximum('consecutivo')
      if con.nil?
        con = 1
      else
        con += 1
      end
      consecutivo = "%03d" % con
      self.consecutivo = con
      self.codigo = "#{self.solicitud.codigo}-S#{consecutivo}"
      self.save(:validate => false)
    end

  end
end
