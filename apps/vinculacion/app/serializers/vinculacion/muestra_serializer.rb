module Vinculacion
  class MuestraSerializer < ActiveModel::Serializer
  	attributes :solicitud_id, :usuario_id
    attributes :id, :consecutivo, :codigo, :identificacion, :descripcion, :cantidad, :status
    has_one :solicitud
  end
end
