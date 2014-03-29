module Vinculacion
  class CotizacionDetalleSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id
    attributes :cantidad, :concepto, :precio_unitario, :status
    has_one :cotizacion
  end
end
