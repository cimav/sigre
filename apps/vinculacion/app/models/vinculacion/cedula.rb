# coding: utf-8
module Vinculacion
  class Cedula < ActiveRecord::Base
    belongs_to :solicitud
    has_many :costo_variable
    has_many :remanentes

    attr_accessor :total_costo_variable
    attr_accessor :costo_indirecto
    attr_accessor :costo_interno
    attr_accessor :porcentaje_participacion
    attr_accessor :utilidad
    attr_accessor :precio_venta
    attr_accessor :remanente_distribuible

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

  end
end
