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
    before_destroy :destroy_cotizacion

    belongs_to :servicio_bitacora

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
      if self.solicitud.tipo == 4
        self.codigo = "#{self.solicitud.codigo}-P#{consecutivo}"
      else
        self.codigo = "#{self.solicitud.codigo}-S#{consecutivo}"
      end
      self.save(:validate => false)
    end

    def add_cedula

      # A cada servicio le corresponde una cédula

      cedula = self.solicitud.cedulas.new
      cedula.servicio = self
      cedula.solicitud = self.solicitud
      cod = self.codigo
      if self.solicitud.tipo == 4
        cod["P"] = "C"
      else
        cod["S"] = "C"
      end
      cedula.codigo = cod
      cedula.status = 1
      cedula.save

    end


    def check_solicitud_status
      puts "CHECK SOLICITUD STATUS"
      # El Status de servicios depende de la agrupación de todos los servicios de la solicitud

      if self.status_changed?
        puts "SI CAMBIO EL STATUS"
        if self.status == EN_PROCESO

          # TODO en depuracion

          last_cotiza = self.solicitud.cotizaciones.last
          puts "ULTIMA COTIZACION"
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
          puts "FINALIZANDO SERVICIO #{self.id}"
          # todos deben estar en FINALIZADO
          todosEnFinalizado = true
          self.solicitud.servicios.each do |servicio|
            puts "SERVICIO: #{servicio.id} ESTADO: #{servicio.status}"
            if servicio.status != FINALIZADO && servicio.status != CANCELADO
              todosEnFinalizado = false
              break
            end
          end
          puts todosEnFinalizado

          if todosEnFinalizado
            puts "ACTUALIZANDO STATUS DE SOLICITUD #{self.solicitud.id}"
            self.solicitud.status = Solicitud::STATUS_FINALIZADA
            if self.solicitud.save!
              puts "SOLICITUD ACTUALIZADA"
            else
              puts "ERROR AL ACTUALIZAR SOLICITUD"
            end

          end


        end


      end
    end

    def relation_string
      "#{empleado_id},#{solicitud_id}"
    end

    def destroy_cotizacion
      # al borrar un servicio, borrar los Detalles (de la ultima Cotizacion) que lo refieren
      lastCotizaId = self.solicitud.ultima_cotizacion.id rescue 0
      CotizacionDetalle.where("cotizacion_id = #{lastCotizaId} AND servicio_id = #{self.id}").destroy_all
    end

  end
end
