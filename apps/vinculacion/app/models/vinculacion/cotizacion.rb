# encoding: UTF-8
module Vinculacion
  class Cotizacion < ActiveRecord::Base
    belongs_to :solicitud
    has_many :cotizacion_detalle

    IVA = 16

    STATUS_EDICION              = 1
    STATUS_NOTIFICADO           = 2
    STATUS_ACEPTADO             = 3
    STATUS_RECHAZADO            = 4
    STATUS_DESCUENTO_SOLICITADO = 5
    STATUS_DESCUENTO_ACEPTADO   = 6
    STATUS_DESCUENTO_RECHAZADO  = 7
    STATUS_CANCELADO            = 99

    COMENTARIOS = "En respuesta a su solicitud para traducción de informe y agradeciendo su preferencia, ponemos a su
consideración la siguiente propuesta económica:"

    OBSERVACIONES = ""

    NOTAS = "Esta cotización tiene una vigencia de 30 días hábiles.\nLa duración del servicio es de 30 días hábiles posteriores a la recepción de la orden de compra."

    after_create :set_extra
    before_update :update_fecha_notificacion
    after_update :clone_cotizacion
    after_update :check_solicitud_status

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
        self.comentarios = COMENTARIOS
        self.observaciones = OBSERVACIONES
        self.notas = NOTAS
        self.subtotal = 0.00
        self.precio_venta = 0.00
        self.descuento_porcentaje = 0.00
        self.msg_notificacion = ''
        self.motivo_status = ''
        self.motivo_descuento = ''
        self.duracion = 0
        self.fecha_notificacion = Time.now
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
        self.fecha_notificacion = Time.now # la fecha actual, no la clonada

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

    def update_fecha_notificacion
      if self.status == STATUS_NOTIFICADO
        self.fecha_notificacion = Date.today()
      end
    end

    def clone_cotizacion
      if self.status == STATUS_RECHAZADO
        cotizacion = self.solicitud.cotizaciones.new
        cotizacion.save
      end
    end

    def check_solicitud_status

      # Los Status cambian sobre la última cotización (actual). No hay necesidad de revisar las anteriores.

      if self.status_changed?

        if self.status == STATUS_EDICION
          self.solicitud.status = Solicitud::STATUS_EN_COTIZACION
          self.solicitud.save

        elsif self.status == STATUS_ACEPTADO
          self.solicitud.status = Solicitud::STATUS_ACEPTADA
          self.solicitud.save

        end
      end
    end

  end
end
