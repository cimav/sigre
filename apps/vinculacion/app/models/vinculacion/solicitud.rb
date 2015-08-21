# coding: utf-8
module Vinculacion
  class Solicitud < ActiveRecord::Base
    has_many :muestras
    has_many :servicios
    has_many :cedulas
    has_many :cotizaciones

    belongs_to :sede
    belongs_to :proyecto
    belongs_to :cliente
    belongs_to :contacto
    belongs_to :usuario
    belongs_to :responsable_presupuestal, class_name: "Empleado"

    after_create :set_extra
    after_create :add_cotizacion
    before_create :init_status
    after_update :check_status

    attr_accessor :costo_interno
    attr_accessor :ultima_cotizacion
    attr_accessor :precio_venta


    TIEMPO_NORMAL = 1
    TIEMPO_URGENTE = 2
    TIEMPO_EXPRESS = 3

    TIEMPO = {
      TIEMPO_NORMAL  => 'Normal',
      TIEMPO_URGENTE => 'Urgente',
      TIEMPO_EXPRESS => 'Express'
    }

    STATUS_INICIAL        = 1
    STATUS_EN_COTIZACION  = 2
    STATUS_ACEPTADA       = 3
    STATUS_EN_PROCESO     = 4
    STATUS_FINALIZADA     = 5
    STATUS_CANCELADA      = 99

    STATUS = {
        STATUS_INICIAL        => 'Inicial',
        STATUS_EN_COTIZACION  => 'En cotización',
        STATUS_ACEPTADA       => 'Aceptada',
        STATUS_EN_PROCESO     => 'En proceso',
        STATUS_FINALIZADA     => 'Finalizada',
        STATUS_CANCELADA      => 'Cancelada',
    }

    def status_text
      STATUS[status.to_i]
    end

    def tiempo_text
      TIEMPO[tiempo_entrega.to_i]
    end

    def init_status
      self.status ||= "1"
      self.fecha_inicio ||= Time.now
      self.fecha_termino ||= Time.now
    end

    def relation_string
      "#{proyecto_id},#{sede_id},#{cliente_id},#{contacto_id}"
    end

  	def set_extra
  	  con = Solicitud.where("EXTRACT(YEAR FROM created_at) = :year", {:year => Date.today.year}).maximum('consecutivo')
      if con.nil?
        con = 1
      else
        con += 1
      end
      consecutivo = "%04d" % con
      self.consecutivo = con
      year = Date.today.year.to_s.last(2)
      self.codigo = "#{year}/#{consecutivo}"
      self.vinculacion_hash = SecureRandom.hex(8)
      self.save(:validate => false)
  	end

    def add_cotizacion
      cotizacion = self.cotizaciones.new
      cotizacion.save
    end

    def costo_interno
      total = 0
      self.cedulas.each do |cedula|
        total = total + cedula.costo_interno
      end
      return total
    end

    def ultima_cotizacion
      Cotizacion.where("solicitud_id = :sol_id", {:sol_id => self.id}).order('created_at').last
    end

    def precio_venta
      if !ultima_cotizacion.nil?
        ultima_cotizacion.precio_venta
      else 
        0
      end
    end

    def check_status

      if self.status_changed?

        if self.status == STATUS_CANCELADA

          # El controlador Notifica a Bitacora publicando cancelar_solicitud

          # cancelar ultima cotización
          ultima_cotiza = ultima_cotizacion
          ultima_cotiza.status = Cotizacion::STATUS_CANCELADO
          ultima_cotiza.save

          # cancelar todos los servicios
          self.servicios.each do |servicio|
            servicio.status = Servicio::CANCELADO
            servicio.save
          end

        end

      end
    end

  end
end
