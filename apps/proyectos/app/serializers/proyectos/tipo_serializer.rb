module Proyectos
  class TipoSerializer < ActiveModel::Serializer
    embed :ids, :include => true

    attributes :id
    attributes :nombre

    has_many :recursos

  end
end