# coding: utf-8
module Vinculacion
  class Remanente < ActiveRecord::Base

    belongs_to :cedula

    def remanente_distribuible
      self.porcentaje_participacion * self.servicio.remanente_distribuible / 100
      # NOTE No esta persistiendo el monto
    end

    # Code para persistir al monto
    # attr_accessor :monto_remanente
    #
    # def monto_remanente
    #   monto_old = self.monto
    #   monto_new = self.porcentaje_participacion * self.servicio.remanente_distribuible / 100
    #   if (monto_old-monto_new).abs>0.01
    #     self.monto = monto_new
    #     self.save
    #   end
    #   return monto_new
    # end

  end

end