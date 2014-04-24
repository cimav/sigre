module Vinculacion
  class Cotizacion < ActiveRecord::Base
    belongs_to :solicitud
    has_many :cotizacion_detalle

    IVA = 16

    STATUS_EDICION    = 1
    STATUS_NOTIFICADO = 2
    STATUS_ACEPTADO   = 3
    STATUS_RECHAZADO  = 4
    STATUS_CANCELADO  = 5
  
    after_create :set_extra

    def set_extra

      self.status = STATUS_EDICION
      
  	  ultima_cotizacion = Cotizacion.where("solicitud_id = :s AND id <> :id", {:s => self.solicitud_id, :id => self.id}).order('created_at').last

      if ultima_cotizacion.nil?
        self.consecutivo = 'A'
        self.iva = Cotizacion::IVA
      else
        self.consecutivo = ultima_cotizacion.consecutivo.next
        # Clonar cotizacion anterior.
        self.iva = ultima_cotizacion.iva
        self.condicion = ultima_cotizacion.condicion
        self.idioma = ultima_cotizacion.idioma
        self.divisa = ultima_cotizacion.divisa
        self.comentarios = ultima_cotizacion.comentarios
        self.observaciones = ultima_cotizacion.observaciones
        self.notas = ultima_cotizacion.notas
        self.subtotal = ultima_cotizacion.subtotal
        self.precio_venta = ultima_cotizacion.precio_venta
        self.precio_unitario = ultima_cotizacion.precio_unitario
        self.descuento_porcentaje = ultima_cotizacion.descuento_porcentaje
        self.descuento_status = ultima_cotizacion.descuento_status
        # TODO: Clonar detalle
      end
      self.save(:validate => false)
  	end

    
  end
end
