module Vinculacion
  class ServiciosMuestrasSerializer < ActiveModel::Serializer
    embed :ids
    attributes :id
    has_one :servicio
    has_one :muestra
  end
end
