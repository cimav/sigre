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
    after_update :clone_cotizacion

    def codigo 
      "#{self.solicitud.codigo}-#{consecutivo}"
    end

    def set_extra

      self.status = STATUS_EDICION
      
  	  ultima_cotizacion = Cotizacion.where("solicitud_id = :s AND id <> :id", {:s => self.solicitud_id, :id => self.id}).order('created_at').last

      if ultima_cotizacion.nil?
        self.consecutivo = 'A'
        # Valores Default
        self.iva = Cotizacion::IVA
        self.condicion = 1
        self.idioma = 1
        self.divisa = 1
        self.comentarios = 'Comentarios default...'
        self.observaciones = 'Observaciones default...'
        self.notas = 'Notas default...'
        self.subtotal = 0.00
        self.precio_venta = 0.00
        self.descuento_porcentaje = 0.00
        self.descuento_status = 0
        self.msg_notificacion = ''
        self.motivo_status = ''
        self.duracion = 0
      else
        self.consecutivo = ultima_cotizacion.consecutivo.next
        # Clonar cotizacion anterior.
        self.iva = ultima_cotizacion.iva
        self.duracion = ultima_cotizacion.duracion
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

        # Clonar detalle
        ultima_cotizacion.cotizacion_detalle.each do |detalle|
          # TODO Checkar orden
          CotizacionDetalle.create(
              :cotizacion_id => self.id,
              :cantidad => detalle.cantidad,
              :concepto => detalle.concepto,
              :precio_unitario => detalle.precio_unitario,
              :status => detalle.status)
        end

      end
      self.save(:validate => false)
  	end


    def clone_cotizacion
      if self.status == STATUS_RECHAZADO
        cotizacion = self.solicitud.cotizaciones.new
        cotizacion.save
      end
    end

    
  end
end
