module Proyectos
  class DepartamentoSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id, :nombre, :descripcion
  end
end
