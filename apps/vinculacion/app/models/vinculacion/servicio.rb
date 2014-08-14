# coding: utf-8
module Vinculacion
  class Servicio < ActiveRecord::Base
    belongs_to :solicitud
    belongs_to :empleado
    has_one :cedula
    has_many :costeos
    has_and_belongs_to_many :muestras, :join_table => :vinculacion_servicios_muestras

    after_create :set_extra
    after_create :add_cedula
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

      con = 0
      begin
        sql_stmt = "SELECT MAX(v_srvs.consecutivo) FROM vinculacion_solicitudes v_sol JOIN vinculacion_servicios v_srvs ON v_sol.id = v_srvs.solicitud_id WHERE v_sol.proyecto_id = #{self.solicitud.proyecto_id};"
        result = ActiveRecord::Base.connection.execute(sql_stmt)
        con = result[0]['max'].to_f
        con += 1
      rescue => e
        con = 1
      end

      consecutivo = "%03d" % con
      self.consecutivo = con
      self.codigo = "#{self.solicitud.codigo}-S#{consecutivo}"
      self.save(:validate => false)
    end

    def add_cedula
      # A cada Servicio le corresponde una Cédula
      cedula = self.solicitud.cedulas.new
      cedula.servicio = self;
      cedula.solicitud = self.solicitud;
      cod = self.codigo
      cod["S"] = "C"
      cedula.codigo = cod
      cedula.status = 1;
      cedula.save
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
