module Vinculacion
  class MuestraDetalleSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id
    attributes :muestra_id
    attributes :consecutivo, :cliente_identificacion, :notas, :status
  end
end
