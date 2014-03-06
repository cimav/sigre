module Rh
  class EmpleadoSerializer < ActiveModel::Serializer
  	attributes :departamento_id, :sede_id, :empleado_id
    attributes :id, :nombre, :apellido_paterno, :apellido_materno, :email
    has_one :departamento
    has_one :sede
    attributes :nombre_completo
  end
end
