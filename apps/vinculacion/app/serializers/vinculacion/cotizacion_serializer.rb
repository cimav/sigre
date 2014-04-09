module Vinculacion
  class CotizacionSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id
    attributes :solicitud_id
    attributes :consecutivo, :fecha_notificacion, :condicion, :idioma, :divisa, :comentarios, :observaciones, :notas, :subtotal
    attributes :precio_venta, :precio_unitario, :descuento_porcentaje, :descuento_status, :status, :msg_notificacion, :motivo_status
    has_many  :cotizaciones_detalle

  end
end
