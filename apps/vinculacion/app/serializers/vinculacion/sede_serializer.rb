module Vinculacion
  class SedeSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id, :nombre, :descripcion
  end
end
