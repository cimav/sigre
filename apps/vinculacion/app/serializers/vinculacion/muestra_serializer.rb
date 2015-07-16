module Vinculacion
  class MuestraSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id
    attributes :solicitud_id, :usuario_id
    attributes :consecutivo, :codigo, :identificacion, :descripcion, :cantidad, :status
    has_many :muestra_detalle
  end
end
