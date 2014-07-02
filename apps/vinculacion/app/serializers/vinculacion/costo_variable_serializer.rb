module Vinculacion
  class CostoVariableSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id
    attributes :servicio_id
    attributes :tipo, :descripcion, :costo
  end
end
