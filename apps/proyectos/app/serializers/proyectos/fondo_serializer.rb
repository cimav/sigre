module Proyectos
  class FondoSerializer < ActiveModel::Serializer
    embed :ids, :include => true

    attributes :id
    attributes :nombre, :descripcion

  end
end