module Proyectos
  class RecursoSerializer < ActiveModel::Serializer
    embed :ids, :include => true

    attributes :id
    attributes :nombre, :descripcion

    has_one :tipo

  end
end