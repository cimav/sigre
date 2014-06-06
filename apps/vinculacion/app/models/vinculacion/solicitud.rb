# coding: utf-8
module Vinculacion
  class Solicitud < ActiveRecord::Base
    has_many :muestras
    has_many :servicios
    has_many :cotizaciones

    belongs_to   :sede
    belongs_to  :proyecto
    belongs_to  :cliente
    belongs_to  :contacto

    after_create :set_extra
    after_create :add_cotizacion
    before_create :init_status

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

    def init_status
      self.status ||= "1"
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
      self.save(:validate => false)
  	end

    def add_cotizacion
      cotizacion = self.cotizaciones.new
      cotizacion.save
    end

  end
end
