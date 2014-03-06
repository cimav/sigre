module Rh
  class DepartamentoSerializer < ActiveModel::Serializer
    attributes :id, :nombre, :descripcion, :sede_id, :empleado_id, :departamento_id
  end
end
