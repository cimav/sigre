module Proyectos
  class RecursoSerializer < ActiveModel::Serializer
    embed :ids, :include => true

    attributes :id
    attributes :nombre, :descripcion

    attributes :tipo_id

  end
end