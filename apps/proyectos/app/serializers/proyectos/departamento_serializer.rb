module Proyectos
  class DepartamentoSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id, :nombre, :descripcion

    has_many :empleado
  end
end
