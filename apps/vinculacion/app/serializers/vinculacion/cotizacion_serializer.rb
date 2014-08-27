module Vinculacion
  class CotizacionSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id
    attributes :solicitud_id
    attributes :consecutivo, :fecha_notificacion, :condicion, :idioma, :divisa, :comentarios, :observaciones, :notas, :subtotal, :iva
    attributes :precio_venta, :precio_unitario, :descuento_porcentaje, :status, :msg_notificacion, :motivo_status, :motivo_descuento, :duracion
    attributes :codigo
    attributes :status_text
    has_many  :cotizacion_detalle
 #   has_one :solicitud
  end
end
