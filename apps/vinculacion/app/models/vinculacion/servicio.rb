# coding: utf-8
module Vinculacion
  class Servicio < ActiveRecord::Base
    belongs_to :solicitud
    belongs_to :empleado
    has_many :costeos
    has_and_belongs_to_many :muestras, :join_table => :vinculacion_servicios_muestras
    has_many :costo_variable
    has_many :remanentes

    after_create :set_extra
    after_update :check_solicitud_status

    attr_accessor :total_costo_variable
    attr_accessor :costo_indirecto
    attr_accessor :costo_interno
    attr_accessor :porcentaje_participacion
    attr_accessor :utilidad
    attr_accessor :precio_venta
    attr_accessor :remanente_distribuible

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

    def total_costo_variable
      self.costo_variable.sum('costo')
    end

    def costo_indirecto
      self.total_costo_variable * 0.1726
    end

    def costo_interno
      self.total_costo_variable + self.costo_indirecto
    end

    def porcentaje_participacion
      self.costo_interno * 100 / self.solicitud.costo_interno
    end

    def precio_venta
      self.porcentaje_participacion * self.solicitud.precio_venta / 100
    end

    def utilidad
      self.precio_venta - self.costo_interno
    end

    def remanente_distribuible
      tope = 70 * self.precio_venta / 100
      topado = self.utilidad > tope ? tope : self.utilidad
      topado * 0.35
    end

    def check_solicitud_status

      # El Status de servicios depende de la agrupación de todos los servicios de la solicitud

      if self.status_changed?

        if self.status == EN_PROCESO

          # TODO en depuracion

          last_cotiza = self.solicitud.cotizaciones.last
          puts last_cotiza
          cotiza_is_aceptada = !last_cotiza.nil? and last_cotiza.status == Cotizacion::STATUS_ACEPTADO
          puts cotiza_is_aceptada
          # para pasar a proceso, la cotizacion debe estar aceptada
          if cotiza_is_aceptada
            # todos deben estar en EN_PROCESO
            todosEnProceso = true
            self.solicitud.servicios.each do |servicio|
              puts servicio.status
              if servicio.status != EN_PROCESO
                todosEnProceso = false
                break
              end
            end
            puts todosEnProceso
            if todosEnProceso
              self.solicitud.status = Solicitud::STATUS_EN_PROCESO
              self.solicitud.save
            end
          end
          puts self.solicitud.status

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
