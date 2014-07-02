module Vinculacion
  class RemanenteSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id
    attributes :servicio_id, :empleado_id
    attributes :porcentaje_participacion, :monto
  end
end
