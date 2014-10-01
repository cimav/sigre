module Proyectos
  class DepartamentoSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id, :nombre, :descripcion

    attributes  :sede_id

    has_many :empleado
  end
end
