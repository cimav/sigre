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

    STATUS = {
        STATUS_EDICION              => "en edición",
        STATUS_NOTIFICADO           => "en espera de respuesta del cliente",
        STATUS_ACEPTADO             => "aceptada",
        STATUS_RECHAZADO            => "rechazada",
        STATUS_DESCUENTO_SOLICITADO => "en espera de autorización descuento",
        STATUS_DESCUENTO_ACEPTADO   => "con descuento aceptado",
        STATUS_DESCUENTO_RECHAZADO  => "con descuento rechazado",
        STATUS_CANCELADO            => "cancelada"
    }

    def status_text
      STATUS[status.to_i]
    end

    MENSAJE = "En respuesta a su solicitud de SOLICITUD_DESCRIPCION y agradeciendo su preferencia, ponemos a su
consideración la siguiente propuesta económica:"

    MENSAJE_CORREO = "Estimado cliente, se adjunta cotización solicitada.
      
Saludos."

    MENSAJE_DE_SERVICIO = "servicio"

    OBSERVACIONES = ""

    # NOTAS = "La duración del servicio es de 30 días hábiles posteriores a la recepción de la orden de compra."

    after_create :set_extra
    before_update :update_fecha_notificacion
    after_update :clone_cotizacion
    after_update :check_solicitud_status
    after_update :update_tiempo_entrega_detalle

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
        if self.solicitud.descripcion.nil? || self.solicitud.descripcion.empty?
          self.comentarios = MENSAJE.gsub("SOLICITUD_DESCRIPCION", MENSAJE_DE_SERVICIO)
        else
          self.comentarios = MENSAJE.gsub("SOLICITUD_DESCRIPCION", self.solicitud.descripcion)
        end
        self.observaciones = OBSERVACIONES
        self.notas = '' #NOTAS
        self.subtotal = 0.00
        self.precio_venta = 0.00
        self.descuento_porcentaje = 0.00
        self.msg_notificacion = MENSAJE_CORREO
        self.motivo_status = ''
        self.motivo_descuento = ''
        self.duracion = 0
        self.fecha_notificacion = Time.now
        self.tiempo_entrega = solicitud.tiempo_entrega
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
        self.msg_notificacion = ultima_cotizacion.msg_notificacion
        self.fecha_notificacion = Time.now # la fecha actual, no la clonada
        # self.tiempo_entrega = ultima_cotizacion.tiempo_entrega
        self.tiempo_entrega = solicitud.tiempo_entrega

        # Clonar detalle
        ultima_cotizacion.cotizacion_detalle.each do |detalle|
          CotizacionDetalle.create(
              :cotizacion_id => self.id,
              :cantidad => detalle.cantidad,
              :concepto => detalle.concepto,
              :precio_unitario => detalle.precio_unitario,
              :servicio_id => detalle.servicio_id,
              :inmutable => detalle.inmutable
          )
        end

      end
      self.save(:validate => false)
    end

    def update_tiempo_entrega_detalle
      # Si el detalle de la cotización tiene un servicio, significa que es del tipo 1 o 2.
      # Dicho servicio tiene un servicio_bitacora de donde se saca el precio_venta
      if self.tiempo_entrega_changed?
        self.cotizacion_detalle.where("servicio_id >= 0").each do |detalle|
          srv_bit_id = Servicio.find(detalle.servicio_id).servicio_bitacora_id rescue 0
          if !srv_bit_id.nil? and srv_bit_id > 0
            srv_bit = ServicioBitacora.find(srv_bit_id)
            precio_venta = srv_bit.nil? ? 0 : srv_bit.precio_venta
            detalle.precio_unitario = self.tiempo_entrega * precio_venta
            detalle.save
          end
        end
      end
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
