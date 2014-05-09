# coding: utf-8
module Vinculacion
  class Servicio < ActiveRecord::Base
    belongs_to :solicitud
    belongs_to :empleado
    has_many   :costeos
    has_and_belongs_to_many :muestras, :join_table => :vinculacion_servicios_muestras

    after_create :set_extra
    after_update :check_solicitud_status

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

    def check_solicitud_status

      # El Status de servicios depende de la agrupación de todos los servicios de la solicitud

      if self.status_changed?

        if self.status == ESPERANDO_COSTEO

          # basta con uno este en ESPERANDO_COSTEO
          self.solicitud.status = Solicitud::STATUS_ESPERANDO_COSTEO
          self.solicitud.save

        elsif self.status == EN_PROCESO

          # todos deben estar en EN_PROCESO
          todosEnProceso = true
          self.solicitud.servicios.each do |servicio|
            if servicio.status != EN_PROCESO
              todosEnProceso = false
              break
            end
          end
          if todosEnProceso
            self.solicitud.status = Solicitud::STATUS_EN_PROCESO
            self.solicitud.save
          end

        elsif self.status == FINALIZADO

          # todos deben estar en FINALIZADO
          todosEnFinalizado = true
          self.solicitud.servicios.each do |servicio|
            if servicio.status != FINALIZADO
              todosEnFinalizado = false
              break
            end
          end
          if todosEnFinalizado
            self.solicitud.status = Solicitud::STATUS_FINALIZADA
            self.solicitud.save
          end

        end

      end
    end

  end
end
