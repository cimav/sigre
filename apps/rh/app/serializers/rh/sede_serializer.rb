module Rh
  class SedeSerializer < ActiveModel::Serializer
    attributes :id, :nombre, :descripcion, :empleado_id
  end
end
