module Vinculacion
  class VinculacionMailer < ApplicationMailer
    def servicios_alertados(alerta_id, mensaje, afectados)
      @from = "Bitácora Electrónica <bitacora.electronica@cimav.edu.mx>"
      @to = []

       # Usuarios de Servicios Vinculación
      @to << 'ion@cimav.edu.mx'
      #@to << 'karen.valles@cimav.edu.mx'
      @afectados = afectados
      @mensaje = mensaje
        
      subject = "[Vinculación] Alerta ##{alerta_id}"
      mail(:to => @to, :from => @from, :subject => subject)
    end

    def alerta_resuelta(alerta_id)
      @from = "Bitácora Electrónica <bitacora.electronica@cimav.edu.mx>"
      @to = []

       # Usuarios de Servicios Vinculación
      @to << 'ion@cimav.edu.mx'
      @alerta_id = alerta_id
      #@to << 'karen.valles@cimav.edu.mx'
        
      subject = "[Vinculación] Alerta ##{alerta_id} Resuelta"
      mail(:to => @to, :from => @from, :subject => subject)
    end
  end
end
