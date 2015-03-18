module Vinculacion
  class SedeSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id, :nombre, :descripcion

    has_many :servicio_bitacora
  end
end
