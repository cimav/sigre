module Vinculacion
  class CotizacionDetalleSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id
    attributes :cotizacion_id
    attributes :cantidad, :concepto, :precio_unitario, :status, :inmutable, :servicio_id
  end
end
