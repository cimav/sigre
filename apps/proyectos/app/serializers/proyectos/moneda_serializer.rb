module Proyectos
  class MonedaSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id, :codigo, :nombre
  end
end
