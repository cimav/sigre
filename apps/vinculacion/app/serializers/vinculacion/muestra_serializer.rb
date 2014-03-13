module Vinculacion
  class MuestraSerializer < ActiveModel::Serializer
  	attributes :solicitud_id, :usuario_id
    attributes :id, :consecutivo, :codigo, :identificacion, :descripcion, :cantidad, :status
  end
end
