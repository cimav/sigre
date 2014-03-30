module Vinculacion
  class CosteoDetalleSerializer < ActiveModel::Serializer
  	embed :ids, :include => true
    attributes :id
    attributes :tipo, :descripcion, :cantidad, :precio_unitario, :status
  end
end