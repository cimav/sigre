module Vinculacion
  class CotizacionSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id
    attributes :consecutivo, :fecha_notificacion, :condicion_pago_id, :idioma_id, :divisa_id, :comentarios, :observaciones, :notas, :subtotal, :precio_venta, :precio_unitario, :descuento_porcentaje, :descuento_status, :status
    has_many  :cotizaciones_detalle
  end
end
