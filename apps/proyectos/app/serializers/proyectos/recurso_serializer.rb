module Proyectos
  class RecursoSerializer < ActiveModel::Serializer
    embed :ids, :include => true

    attributes :id
    attributes :tipo_id
    attributes :nombre, :descripcion

    #has_one :tipo #provoca un Stack level too deep

  end
end