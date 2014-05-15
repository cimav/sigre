# coding: utf-8
module Vinculacion
  class Servicio < ActiveRecord::Base
    belongs_to :solicitud
    belongs_to :empleado
    has_many :costeos
    has_and_belongs_to_many :muestras, :join_table => :vinculacion_servicios_muestras

    after_create :set_extra
    after_update :check_solicitud_status

    INICIAL             = 1
    ESPERANDO_COSTEO    = 2
    ESPERANDO_ARRANQUE  = 3
    EN_PROCESO          = 4
    FINALIZADO          = 5
    CANCELADO           = 99

    STATUS = {
        INICIAL             => 'Inicio',
        ESPERANDO_COSTEO    => 'Esperando costeo',
        ESPERANDO_ARRANQUE  => 'Esperando arranque',
        EN_PROCESO          => 'En proceso',
        FINALIZADO          => 'Finalizado',
        CANCELADO           => 'Cancelado',
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

        if self.status == EN_PROCESO

          last_cotiza = self.solicitud.cotizaciones.last
          cotiza_is_aceptada = !last_cotiza.nil? and last_cotiza.status == Cotizacion::STATUS_ACEPTADO
          # para pasar a proceso, la cotizacion debe estar aceptada
          if cotiza_is_aceptada
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
